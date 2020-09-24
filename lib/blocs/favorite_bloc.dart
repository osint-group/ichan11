import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:iChan/blocs/thread/event.dart';
import 'package:iChan/models/thread_storage.dart';
import 'package:iChan/models/post.dart';

import 'package:iChan/repositories/repositories.dart';
import 'package:iChan/services/exports.dart';
import 'package:iChan/services/extensions.dart';
import 'package:retry/retry.dart';
import 'package:iChan/services/my.dart' as my;

// Upgraded to Cubit instead of Bloc
class FavoriteBloc extends Cubit<FavoriteState> {
  FavoriteBloc({@required this.repo}) : super(FavoriteReady());

  static const minRefreshTime = 1350;
  static const nonFavoriteRefreshTime = 24 * 3600;

  final Repo repo;
  List<ThreadStorage> favoritesList;
  List<ThreadStorage> repliesList;

  Future reloadFavorites() async {
    favoritesList = _getFavoritesList();
    repliesList = _getRepliesList();
  }

  Future refreshManual() async {
    favoritesList ??= _getFavoritesList();
    repliesList ??= _getRepliesList();

    if (favoritesList.isEmpty && repliesList.isEmpty) {
      return;
    }

    final refreshStartedAt = DateTime.now().millisecondsSinceEpoch;

    emit(FavoriteReloading());
    emit(FavoriteRefreshInProgress());
    final List<ThreadStorage> _list0 = favoritesList
        .where((e) => _isNotDeletedAndActive(e))
        .sortedBy((a, b) => b.visits != null ? b.visits.compareTo(a.visits) : 0)
        .toList();

    final lastVisited =
        favoritesList.sortedBy((a, b) => b.visitedAt.compareTo(a.visitedAt)).take(3).toList();

    final myThreads = favoritesList.where((e) => e.isOp).take(3).toList();

    final _list = (myThreads + lastVisited + _list0 + repliesList).toSet().toList();

    // Log.warn("Refresh ${_list.length} items");
    await _refeshAll(_list, force: _list.length <= 5);
    my.prefs.incrStats('favs_refreshed');

    final diff = minRefreshTime - refreshStartedAt.timeDiff;

    if (diff > 0) {
      await Future.delayed(Duration(milliseconds: diff));
    }

    // print("Ready");

    emit(FavoriteReady());
  }

  // maybe remove this
  Future refreshAuto() async {
    return await refreshManual();
  }

  Future clearDeleted() async {
    emit(FavoriteReloading());

    final keys =
        my.favs.box.values.where((e) => e.status == Status.deleted).map((e) => e.key).toList();
    my.favs.box.deleteAll(keys);

    emit(FavoriteReady());
  }

  Future clearVisited([ThreadStorage fav]) async {
    emit(FavoriteReloading());

    if (fav == null) {
      final first = my.favs.box.values.first;
      first.refreshedAt += 1;
      first.save();

      my.prefs.box.put("visited_cleared_at", DateTime.now().millisecondsSinceEpoch);
    } else {
      fav.delete();
    }

    emit(FavoriteReady());
  }

  Future favoriteDeleted([ThreadStorage fav]) async {
    emit(FavoriteReloading());
    if (fav.isSaved) {
      fav.delete();
    } else {
      fav.toggleFavorite();
    }
    emit(FavoriteReady());
  }

  Future favoriteUpdated() async {
    emit(FavoriteReloading());
    reloadFavorites();
    emit(FavoriteReady());
  }

  // Private

  List<ThreadStorage> _getFavoritesList() =>
      List.from(my.favs.box.values.where((e) => e.isFavorite));

  List<ThreadStorage> _getRepliesList() => List<ThreadStorage>.from(my.favs.box.values.where((e) =>
      e.ownPostsCount > 0 &&
      e.status != Status.deleted &&
      e.visitedAt.timeDiffInSeconds < nonFavoriteRefreshTime));

  Future _refeshAll(List<ThreadStorage> _list, {bool force = false}) async {
    for (final fav in _list) {
      if (!fav.isFavorite) {
        if (_needToRefresh(fav)) {
          // print("Awaiting non fav");
          await _refresh(fav);
        }
      } else {
        // TODO: parallel refresh on different platforms
        emit(FavoriteRefreshing(fav: fav, status: fav.status));
        if (force || _needToRefresh(fav)) {
          // print("Refreshing fav");
          fav.status = Status.refreshing;
          await _refresh(fav);
        } else {
          // print("Not refreshing fav");
        }
        emit(FavoriteRefreshing(fav: fav, status: fav.status));
      }
    }
  }

  Future<bool> _refresh(ThreadStorage fav) async {
    if (fav.refresh != true) {
      fav.status = Status.disabled;
      return false;
    }

    fav.status = Status.refreshing;

    try {
      final List<Post> posts = await retry(
        () => repo.on(fav.platform).fetchNewPosts(
            threadId: fav.threadId, boardName: fav.boardName, startPostId: fav.unreadPostId),
        maxAttempts: 3,
        delayFactor: 300.milliseconds,
        retryIf: (e) => e is UnavailableException,
      );

      fav.refreshedAt = DateTime.now().millisecondsSinceEpoch;

      if (posts.isNotEmpty) {
        fav.status = Status.unread;
        fav.unreadCount = posts.length;
        fav.extras['last_post_ts'] = posts.last.timestamp * 1000;
        fav.save();
        my.threadBloc.add(ThreadPostsAppended(posts: posts, fav: fav));
      } else {
        fav.status = Status.read;
      }

      return true;
    } on NotFoundException catch (_) {
      if (!fav.isSaved) {
        fav.status = Status.deleted;
      } else {
        fav.status = Status.disabled;
      }
      return false;
    } on UnavailableException catch (_) {
      if (fav.refreshedAt.timeDiffInSeconds >= 60) {
        fav.status = Status.error;
      }
      return false;
    }
  }

  // @override
  // Stream<FavoriteState> mapEventToState(FavoriteEvent event) async* {
  //   favoritesList ??= List.from(my.favs.box.values.where((e) => e.isFavorite));
  //   final repliesList = List<ThreadStorage>.from(my.favs.box.values.where((e) =>
  //       e.ownPostsCount > 0 &&
  //       e.status != Status.deleted &&
  //       e.visitedAt.timeDiffInSeconds < 24 * 3600));

  //   if (event is FavoriteRefreshAllPressed || event is FavoriteRefreshAllAuto) {
  //     final refreshStartedAt = DateTime.now().millisecondsSinceEpoch;
  //     if (favoritesList.isEmpty) {
  //       return;
  //     }

  //     yield FavoriteReloading();
  //     yield FavoriteRefreshInProgress();
  //     final List<ThreadStorage> _list0 = favoritesList
  //         .where((e) => isNotDeletedAndActive(e))
  //         .sortedBy((a, b) => b.visits != null ? b.visits.compareTo(a.visits) : 0)
  //         .toList();

  //     final lastVisited =
  //         favoritesList.sortedBy((a, b) => b.visitedAt.compareTo(a.visitedAt)).take(3).toList();

  //     final myThreads = favoritesList.where((e) => e.isOp).take(3).toList();

  //     final _list = (myThreads + lastVisited + _list0 + repliesList).toSet().toList();

  //     yield* refeshAll(_list, force: _list.length <= 5);
  //     my.prefs.incrStats('favs_refreshed');

  //     final diff = minRefreshTime - refreshStartedAt.timeDiff;

  //     if (diff > 0) {
  //       await Future.delayed(Duration(milliseconds: diff));
  //     }

  //     yield FavoriteReady();
  //   } else if (event is FavoriteClearDeleted) {
  //     yield FavoriteReloading();

  //     final keys =
  //         my.favs.box.values.where((e) => e.status == Status.deleted).map((e) => e.key).toList();
  //     my.favs.box.deleteAll(keys);

  //     yield FavoriteReady();
  //   } else if (event is FavoriteClearVisited) {
  //     yield FavoriteReloading();

  //     if (event.fav == null) {
  //       final first = my.favs.box.values.first;
  //       first.refreshedAt += 1;
  //       first.save();

  //       my.prefs.box.put("visited_cleared_at", DateTime.now().millisecondsSinceEpoch);
  //     } else {
  //       event.fav.delete();
  //     }

  //     yield FavoriteReady();
  //   } else if (event is FavoriteDeleted) {
  //     yield FavoriteReloading();
  //     if (event.fav.isSaved) {
  //       event.fav.delete();
  //     } else {
  //       event.fav.toggleFavorite();
  //     }
  //     yield FavoriteReady();
  //   } else if (event is FavoriteUpdated) {
  //     yield FavoriteReloading();
  //     favoritesList = List.from(my.favs.box.values.where((e) => e.isFavorite));
  //     yield FavoriteReady();
  //   }
  // }

  // Stream<FavoriteState> refeshAll(List<ThreadStorage> _list, {bool force = false}) async* {
  //   for (final fav in _list) {
  //     if (!fav.isFavorite) {
  //       if (_needToRefresh(fav)) {
  //         await refresh(fav);
  //       }
  //     } else {
  //       // TODO: parallel refresh on different platforms
  //       yield FavoriteRefreshing(fav: fav, status: fav.status);
  //       if (force || _needToRefresh(fav)) {
  //         fav.status = Status.refreshing;
  //         await refresh(fav);
  //       }
  //       yield FavoriteRefreshing(fav: fav, status: fav.status);
  //     }
  //   }
  // }

  bool _needToRefresh(ThreadStorage fav) {
    fav.extras['last_post_ts'] ??= fav.visitedAt;
    fav.refreshedAt ??= 0;
    // current unixtime minus last thread refresh unixtime
    final refreshDiff = fav.refreshedAt.timeDiffInSeconds;

    // if user has just visited thread, mark it as higher priority
    final ts = max(fav.extras['last_post_ts'] as int, fav.visitedAt);
    final hoursDiff = ts.timeDiffInHours;

    bool result;
    if (!fav.isFavorite) {
      if (hoursDiff <= 0.2) {
        result = refreshDiff >= 60;
      } else if (hoursDiff <= 2) {
        result = refreshDiff >= 3 * 60;
      } else {
        result = refreshDiff >= 5 * 60;
      }
      return result;
    }

    if (hoursDiff <= 0.2) {
      result = true;
    } else if (hoursDiff <= 1) {
      // print("Diff is $hoursDiff for ${fav.threadTitle} is 5s");
      result = refreshDiff >= 5;
    } else if (hoursDiff <= 2) {
      result = refreshDiff >= 10;
    } else if (hoursDiff <= 3) {
      result = refreshDiff >= 30;
    } else if (hoursDiff <= 6) {
      // print("Diff is $hoursDiff for ${fav.threadTitle} is 15s");
      result = refreshDiff >= 60;
    } else if (hoursDiff <= 12) {
      // print("Diff is $hoursDiff for ${fav.threadTitle} is 60s");
      result = refreshDiff >= 60 * 2;
    } else if (hoursDiff <= 24) {
      // print("Diff is $hoursDiff for ${fav.threadTitle} is 120s");
      result = refreshDiff >= 60 * 5;
    } else if (hoursDiff <= 48) {
      // print("Diff is $hoursDiff for ${fav.threadTitle} is 300s");
      result = refreshDiff >= 60 * 10;
    } else {
      // print("Diff is $hoursDiff for ${fav.threadTitle} is 600");
      result = refreshDiff >= 60 * 15;
    }

    // Log.warn(
    //     "Thread: ${fav.threadId}, hours: ${hoursDiff}, refreshed $refreshDiff sec ago, result is $result");

    return result;
  }

  bool _isNotDeletedAndActive(ThreadStorage fav) =>
      fav.refresh != false && fav.status != Status.deleted && fav.status != Status.closed;
}

// abstract class FavoriteEvent extends Equatable {
//   const FavoriteEvent();
// }

// class FavoriteUpdated extends FavoriteEvent {
//   @override
//   List<Object> get props => [];
// }

// class FavoriteRefreshAllPressed extends FavoriteEvent {
//   @override
//   List<Object> get props => [];
// }

// class FavoriteRefreshAllAuto extends FavoriteEvent {
//   @override
//   List<Object> get props => [];
// }

// class FavoriteDeleted extends FavoriteEvent {
//   const FavoriteDeleted({this.fav});

//   final ThreadStorage fav;

//   @override
//   List<Object> get props => [fav];
// }

// class FavoriteClearDeleted extends FavoriteEvent {
//   const FavoriteClearDeleted();

//   @override
//   List<Object> get props => [];
// }

// class FavoriteClearVisited extends FavoriteEvent {
//   const FavoriteClearVisited({this.fav});

//   final ThreadStorage fav;

//   @override
//   List<Object> get props => [fav];
// }

// STATE
abstract class FavoriteState extends Equatable {
  const FavoriteState({@required this.fav});

  final ThreadStorage fav;

  @override
  List<Object> get props => [fav];
}

class FavoriteRefreshInProgress extends FavoriteState {}

class FavoriteReloading extends FavoriteState {}

class FavoriteReady extends FavoriteState {}

class FavoriteRefreshing extends FavoriteState {
  const FavoriteRefreshing({@required this.fav, this.status}) : assert(fav != null);

  final ThreadStorage fav;
  final Status status;

  @override
  List<Object> get props => [fav, status];
}
