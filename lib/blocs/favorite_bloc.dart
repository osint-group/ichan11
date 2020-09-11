import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:iChan/blocs/thread/event.dart';
import 'package:iChan/models/thread_storage.dart';
import 'package:iChan/models/post.dart';

import 'package:iChan/repositories/repositories.dart';
import 'package:iChan/services/exports.dart';
import 'package:retry/retry.dart';
import 'package:iChan/services/my.dart' as my;

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc({@required this.repo}) : super(FavoriteReady());

  final Repo repo;

  List<ThreadStorage> favoritesList;

  Future<bool> refresh(ThreadStorage fav) async {
    if (fav.refresh != true) {
      fav.status = Status.disabled;
      return false;
    }

    fav.status = Status.refreshing;
    fav.refreshedAt = DateTime.now().millisecondsSinceEpoch;

    try {
      final List<Post> posts = await retry(
        () => repo.on(fav.platform).fetchNewPosts(
            threadId: fav.threadId, boardName: fav.boardName, startPostId: fav.unreadPostId),
        maxAttempts: 3,
        delayFactor: 300.milliseconds,
        retryIf: (e) => e is UnavailableException,
      );

      if (posts.isNotEmpty) {
        fav.status = Status.unread;
        fav.unreadCount = posts.length;
        fav.extras['last_post_ts'] = posts.last.timestamp;
        fav.save();
        my.threadBloc.add(ThreadPostsAppended(posts: posts, fav: fav));
        // my.threadBloc.appendPosts(posts, fav: fav);
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
      fav.status = Status.error;
      return false;
    }
  }

  @override
  Stream<FavoriteState> mapEventToState(FavoriteEvent event) async* {
    favoritesList ??= List.from(my.favs.box.values.where((e) => e.isFavorite));

    // if (isDebug &&  event is FavoriteRefreshAllAuto) {
    //   return;
    // }

    if (event is FavoriteRefreshAllPressed || event is FavoriteRefreshAllAuto) {
      if (favoritesList.isEmpty) {
        return;
      }

      yield FavoriteReloading();
      yield FavoriteRefreshInProgress();
      final _list0 = favoritesList
          .where((e) => isNotDeletedAndActive(e))
          .sortedBy((a, b) => b.visits != null ? b.visits.compareTo(a.visits) : 0)
          .toList();

      final lastVisited =
          favoritesList.sortedBy((a, b) => b.visitedAt.compareTo(a.visitedAt)).take(3).toList();

      final myThreads = favoritesList.where((e) => e.isOp).take(3).toList();

      final _list = (myThreads + lastVisited + _list0).toSet().toList();

      final oldest = favoritesList.maxBy((a, b) => a.refreshedAt.compareTo(b.refreshedAt));

      final needToRefreshAll = event is FavoriteRefreshAllPressed ||
          (event is FavoriteRefreshAllAuto && (secondsPassed(oldest) >= 60 || _list.length <= 5));

      if (needToRefreshAll) {
        yield* refeshAll(_list, force: true);
      } else {
        yield* refeshAll(_list
            .where((f) => f.unreadCount == 0 || secondsPassed(f) >= 60)
            .sortedBy((a, b) => b.visitedAt.compareTo(a.visitedAt))
            .take(10)
            .toList());
      }

      yield FavoriteReady();
    } else if (event is FavoriteClearDeleted) {
      yield FavoriteReloading();

      final keys =
          my.favs.box.values.where((e) => e.status == Status.deleted).map((e) => e.key).toList();
      my.favs.box.deleteAll(keys);

      yield FavoriteReady();
    } else if (event is FavoriteClearVisited) {
      yield FavoriteReloading();

      if (event.fav == null) {
        final first = my.favs.box.values.first;
        first.refreshedAt += 1;
        first.save();

        my.prefs.box.put("visited_cleared_at", DateTime.now().millisecondsSinceEpoch);
      } else {
        event.fav.delete();
      }

      yield FavoriteReady();
    } else if (event is FavoriteDeleted) {
      yield FavoriteReloading();
      if (event.fav.isSaved) {
        event.fav.delete();
      } else {
        event.fav.toggleFavorite();
      }
      yield FavoriteReady();
    } else if (event is FavoriteUpdated) {
      yield FavoriteReloading();
      favoritesList = List.from(my.favs.box.values.where((e) => e.isFavorite));
      yield FavoriteReady();
    }
  }

  Stream<FavoriteState> refeshAll(List<ThreadStorage> _list, {bool force = false}) async* {
    for (final f in _list) {
      // TODO: FIX PLATFORM
      f.status = Status.refreshing;
      yield FavoriteRefreshing(fav: f, status: f.status);
      // print("f.isRefreshedRecently = ${f.isRefreshedRecently}");
      if (force || isRefreshedRecently(f, _list.length) == false) {
        await refresh(f);
      } else {
        // print("Fake refresh");
        await Future.delayed(50.milliseconds);
        f.status = f.unreadCount > 0 ? Status.unread : Status.read;
      }
      yield FavoriteRefreshing(fav: f, status: f.status);
    }
  }

  bool isRefreshedRecently(ThreadStorage f, int count) {
    final refreshPeriod = count <= 3 ? 3 : count <= 10 ? 10 : 15;
    return secondsPassed(f) <= refreshPeriod;
  }

  int secondsPassed(ThreadStorage f) =>
      (DateTime.now().millisecondsSinceEpoch - f.refreshedAt) ~/ (1000);

  bool isNotDeletedAndActive(ThreadStorage fav) =>
      fav.refresh != false && fav.status != Status.deleted;
}

///////// //
// EVENTS //
///////// //
abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
}

class FavoriteUpdated extends FavoriteEvent {
  @override
  List<Object> get props => [];
}

class FavoriteRefreshAllPressed extends FavoriteEvent {
  @override
  List<Object> get props => [];
}

class FavoriteRefreshAllAuto extends FavoriteEvent {
  @override
  List<Object> get props => [];
}

class FavoriteDeleted extends FavoriteEvent {
  const FavoriteDeleted({this.fav});

  final ThreadStorage fav;

  @override
  List<Object> get props => [fav];
}

class FavoriteClearDeleted extends FavoriteEvent {
  const FavoriteClearDeleted();

  @override
  List<Object> get props => [];
}

class FavoriteClearVisited extends FavoriteEvent {
  const FavoriteClearVisited({this.fav});

  final ThreadStorage fav;

  @override
  List<Object> get props => [fav];
}

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
