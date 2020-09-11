import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/scheduler.dart';
import 'package:iChan/blocs/blocs.dart';
import 'package:iChan/blocs/thread/data.dart';
import 'package:iChan/blocs/thread/event.dart';
import 'package:iChan/blocs/thread/state.dart';

import 'package:iChan/models/models.dart';
import 'package:iChan/models/thread_storage.dart';
import 'package:iChan/repositories/repositories.dart';
import 'package:iChan/services/exceptions.dart';
import 'package:iChan/services/exports.dart';
import 'package:iChan/services/my.dart' as my;

class ThreadBloc extends Bloc<ThreadEvent, ThreadState> {
  ThreadBloc({@required this.repo}) : super(const ThreadEmpty());

  final Repo repo;
  final Map<String, ThreadData> _threadDataList = {};
  ThreadData _current;

  ThreadData get current => _current;

  @override
  Stream<ThreadState> mapEventToState(ThreadEvent event) async* {
    // print("=============== $event ===================");
    if (event is ThreadFetchStarted) {
      if (event.force) {
        _threadDataList.remove(event.thread.toKey);
      }

      yield* _threadFetchStartedEvent(event);
    } else if (event is ThreadPostsAppended) {
      final threadData = getThreadData(event.fav.id);

      if (threadData != null) {
        yield ThreadLoading(threadData: threadData);
      }

      _appendPosts(event.posts, fav: event.fav);

      if (threadData != null) {
        yield ThreadLoaded(threadData: threadData);
      }
    } else if (event is ThreadRefreshStarted) {
      if (event.thread.platform == Platform.dvach) {
        yield* _threadRefreshStartedEvent(event);
      } else {
        print("Redirecting to full refresh");
        add(ThreadFetchStarted(thread: event.thread));
      }
      //======================================================================
    } else if (event is ThreadScrollStarted && (state is ThreadLoading == false)) {
      yield* _scrollThreadEvent(event);
    } else if (event is ThreadReportPressed) {
      yield* _threadReportPressedEvent(event);
    } else if (event is ThreadCacheDisabled) {
      _threadDataList.clear();
      _current = ThreadData(thread: Thread.empty());
    } else if (event is ThreadSearchStarted) {
      final q = event.query.toLowerCase();
      final threadData = getThreadData(event.thread.toKey);
      final searchData = threadData.searchData;
      searchData.query = q;
      searchData.pos = event.pos;

      if (q.contains(' ')) {
        searchData.results = searchAll(threadData, q);
      } else {
        searchData.results = searchWord(threadData, q);

        if (searchData.results.isEmpty) {
          searchData.results = searchAll(threadData, q);
        }
      }

      if (searchData.results.isNotEmpty) {
        yield StartScroll(
          threadData: threadData,
          index: searchData.results[searchData.pos - 1],
        );
      } else {
        yield ThreadLoading(threadData: threadData);
      }

      yield ThreadLoaded(threadData: threadData);
    } else if (event is ThreadClosed) {
      yield* _threadClosedEvent(event);
    }
  }

  List<int> searchWord(ThreadData threadData, String query) {
    final List<int> result = [];
    int i = 0;
    for (final post in threadData.posts) {
      final words = post.cleanBody.toLowerCase().split(' ');
      if (words.any((e) => e.startsWith(query))) {
        result.add(i);
        if (result.length >= 100) {
          return result;
        }
      }
      i += 1;
    }
    return result;
  }

  List<int> searchAll(ThreadData threadData, String query) {
    final List<int> result = [];
    int i = 0;
    for (final post in threadData.posts) {
      if (post.cleanBody.toLowerCase().contains(query)) {
        result.add(i);
        if (result.length >= 100) {
          return result;
        }
      }
      i += 1;
    }
    return result;
  }

  Future<bool> listenableReady() async {
    if (_current.scrollData?.listenable?.value?.isNotEmpty != true) {
      await Future.delayed(25.milliseconds);
      return listenableReady();
    } else {
      return Future.value(true);
    }
  }

  Stream<ThreadState> _threadReportPressedEvent(ThreadReportPressed event) async* {
    print("CreateReport event");

    final result = await repo.on(Platform.dvach).createReport(payload: event.payload);
    if (result["ok"] == true) {
      yield ThreadMessage(message: "Report has been sent", threadData: _current);
      yield ThreadLoaded(threadData: _current);
    } else {
      yield ThreadMessage(
        message: result["error"],
        threadData: _current,
      );
      yield ThreadLoaded(threadData: _current);
    }
  }

  Stream<ThreadState> _threadFetchStartedEvent(ThreadFetchStarted event) async* {
    _current = initThreadData(event.thread);

    // _current.myPosts = await my.db.getPostsInThread(_current.thread);

    final isShowCached =
        _current.posts.isNotEmpty && my.prefs.getBool('thread_cache_disabled') == false;

    if (isShowCached) {
      // print("CACHED: ${event.thread.title}");
      _current.status = ThreadStatus.cached;

      yield ThreadLoading(threadData: _current);

      await listenableReady();

      if (_current.thread.platform == Platform.dvach) {
        add(ThreadRefreshStarted(thread: _current.thread));
      } else {
        yield* threadLoad(thread: event.thread, scrollPostId: event.scrollPostId);
      }
    } else {
      if (event.thread.isNotEmpty &&
          (_current.rememberPostId == '' || _current.rememberPostId == event.thread.outerId)) {
        _current.posts = [Post.fromThread(event.thread)];
        _current.thread = event.thread;
        _current.status = ThreadStatus.partial;
        // print("====== LOADING UNREAD INDEX is ${_current.unreadPostIndex}");
        yield ThreadLoading(threadData: _current);
      } else {
        final td = ThreadData(
          status: ThreadStatus.empty,
          thread: event.thread,
        );

        yield ThreadEmpty(
          threadData: td,
        );
      }

      yield* threadLoad(
        thread: event.thread,
        scrollPostId: event.scrollPostId,
        savedJson: _current.threadStorage.savedJson,
      );
    }
  }

  Stream<ThreadState> threadLoad(
      {Thread thread, String scrollPostId = '', String savedJson = ''}) async* {
    assert(thread.platform != null);
    try {
      final data =
          await repo.on(thread.platform).fetchThreadPosts(thread: thread, savedJson: savedJson);

      _current.posts = data["posts"] as List<Post>;
      _current.thread = data["thread"] as Thread;
      // updateFavoriteBefore();

      if (scrollPostId.isNotEmpty) {
        _current.threadStorage.rememberPostId = scrollPostId;
      }

      await SchedulerBinding.instance.scheduleTask<Map<String, List<String>>>(
        () => _parseReplies(_current, _current.posts),
        Priority.animation,
      );
      _current.status = ThreadStatus.loaded;
      _current.refreshedAt = DateTime.now().millisecondsSinceEpoch;

      // print("====== LOADED UNREAD INDEX is ${_current.unreadPostIndex}");
      yield ThreadLoading(threadData: _current);

      await listenableReady();

      yield ThreadLoaded(threadData: _current);
    } on MyException catch (error) {
      if (savedJson == null && _current.threadStorage.savedJson.isNotEmpty) {
        yield* threadLoad(
          thread: thread,
          scrollPostId: scrollPostId,
          savedJson: _current.threadStorage.savedJson,
        );
      } else {
        yield ThreadError(message: error.toString(), code: error.code, threadData: _current);
      }
    }
  }

  Stream<ThreadState> _threadRefreshStartedEvent(ThreadRefreshStarted event) async* {
    _current = initThreadData(event.thread);

    // _current.myPosts = await my.db.getPostsInThread(_current.thread);

    yield ThreadLoading(threadData: _current);
    try {
      final int timestamp = DateTime.now().millisecondsSinceEpoch;
      await getNewPosts(threadId: event.thread.outerId, boardName: event.thread.boardName);
      final int diff = DateTime.now().millisecondsSinceEpoch - timestamp;
      if (diff < 300) {
        await Future.delayed(Duration(milliseconds: 300 - diff));
      }
      if (event.delay != null) {
        await Future.delayed(event.delay);
      }

      // await updateCurrentData(_current.posts);
      _current.status = ThreadStatus.loaded;
      _current.refreshedAt = DateTime.now().millisecondsSinceEpoch;

      // assert(_current.replies != null);

      yield ThreadLoaded(threadData: _current);
      // updateFavoriteAfter();
    } on MyException catch (error) {
      _current.status = ThreadStatus.loaded;
      print("getNewPosts exception: $error");
      yield ThreadError(message: error.toString(), code: error.code, threadData: _current);
    }
  }

  Stream<ThreadState> _threadClosedEvent(ThreadClosed event) async* {
    _current = initThreadData(event.threadData.thread);
    final ts = _current.threadStorage;
    final scrollData = _current.scrollData;
    final posts = _current.posts;

    // log("EVENT Unread post count is ${ts.unreadCount}");

    ts.refreshedAt = DateTime.now().millisecondsSinceEpoch;
    ts.visitedAt = ts.refreshedAt;

    if (ts.unreadCount <= 1) {
      ts.hasReplies = false;
      final unreadPosts = posts.where((e) => e.isUnread && e.isPersisted).toList();
      for (final post in unreadPosts) {
        post.isUnread = false;
        post.save();
      }
    }

    if (posts.isEmpty) {
      // print("POSTS IS EMPTY, RETURN");
      ts.putOrSave();
      scrollData.reset();
      return;
    } else if (posts.length == 1) {
      ts.unreadPostId = posts.first.outerId;
      ts.rememberPostId = posts.first.outerId;
      ts.putOrSave();
      scrollData.reset();
      return;
    }

    if (scrollData?.firstItem == null) {
      ts.putOrSave();
      scrollData.reset();
      return;
    }

    // If its scrolled to the last page,
    final isScrolledToBottom = scrollData.lastIndex + 2 >= posts.length;

    if (isScrolledToBottom) {
      ts.rememberPostId = posts[posts.length - 1].outerId;
    } else {
      final firstItem =
          scrollData.firstIndex > scrollData.lastIndex ? scrollData.lastItem : scrollData.firstItem;

      final readIndicator = (firstItem.itemTrailingEdge - firstItem.itemLeadingEdge) / 2;

      // if we read it at least for 50%, skip to next;
      if (firstItem.itemLeadingEdge.abs() >= readIndicator) {
        final i = firstItem.index + 1;
        final _post = posts.elementAtOrNull(i) ?? posts.last;
        // print("More than 50%, setting to ${_post.outerId}");
        ts.rememberPostId = _post.outerId;
      } else {
        // print("Less than 50%, setting to ${scrollData.firstIndex}");
        ts.rememberPostId = posts[firstItem.index].outerId;
      }
      // print("New remember index: ${scrollData.firstIndex}");
    }

    final unreadPostIndex = posts.length - ts.unreadCount - 1;
    ts.unreadPostId = posts.elementAtOrNull(unreadPostIndex)?.outerId ?? posts.last.outerId;
    scrollData.reset();
    my.favoriteBloc.add(FavoriteUpdated());
    ts.putOrSave();
  }

  Stream<ThreadState> _scrollThreadEvent(ThreadScrollStarted event) async* {
    _current = initThreadData(event.thread);
    // print("_scrollThreadEvent");
    if (_current.posts == null) {
      // print("Returning from scroll");
      return;
    }

    // final double alignment = _current.posts.length >= 5 ? 0.65 : 0.0;
    final scrollTo = event.to ?? "post";

    final ts = _current.threadStorage;

    switch (scrollTo) {
      case "firstUnread":
        final currentPos = _current.scrollData.lastIndex;
        final isScrolledFurther = currentPos >= _current.unreadPostIndex;
        final isNextClick =
            (int.tryParse(ts.rememberPostId) ?? 0) >= (int.tryParse(ts.unreadPostId) ?? 0);

        if (isScrolledFurther || isNextClick) {
          add(ThreadScrollStarted(to: 'last', thread: event.thread));
          return;
        } else {
          ts.rememberPostId = ts.unreadPostId;
          final unreadIndex = _current.unreadPostIndex;
          yield StartScroll(
            threadData: _current,
            index: unreadIndex + 1,
          );
        }
        break;
      case "nextUnread":
        final posts = _current.posts;
        final unreadIndex = _current.unreadPostIndex + 1;

        ts.rememberPostId = posts.elementAtOrNull(unreadIndex)?.outerId ?? posts.last.outerId;

        ts.unreadPostId = ts.rememberPostId;

        yield StartScroll(
          threadData: _current,
          index: unreadIndex + 1,
        );
        break;
      case "last":
        ts.unreadPostId = _current.posts.last.outerId;
        ts.rememberPostId = ts.unreadPostId;
        ts.unreadCount = 0;

        yield StartScroll(
          threadData: _current,
          index: _current.posts.length - 1,
        );
        break;
      case "first":
        ts.rememberPostId = _current.posts.first.outerId;
        yield StartScroll(threadData: _current, index: 0);
        break;
      case "index":
        yield StartScroll(threadData: _current, index: event.index);
        break;
      case "post":
        ts.rememberPostId = event.postId;

        yield StartScroll(
          threadData: _current,
          index: postIdToIndex(postId: event.postId),
        );
        break;
      default:
        print("INVALID EVENT FOR SCROLL: ${event.to}");
    }

    yield ThreadLoaded(threadData: _current);
  }

  void updateFavoriteBefore() async {
    final ts = _current.threadStorage;

    if (ts.isEmpty || ts.isRemembered == false) {
      ts.boardName = _current.thread.boardName;
      ts.threadId = _current.thread.outerId;
      ts.threadTitle = _current.thread.titleOrBody;
      ts.platform = _current.thread.platform;
      ts.unreadPostId = _current.posts.first.outerId;
      ts.unreadCount = _current.posts.length - 1;
      ts.rememberPostId = ts.unreadPostId;
    }

    if (_current.thread.isClosed) {
      ts.status = Status.closed;
    }

    if (ts.threadTitle != _current.thread.titleOrBody) {
      ts.threadTitle = _current.thread.titleOrBody;
    }
    ts.visitedAt = DateTime.now().millisecondsSinceEpoch;
    ts.visits += 1;
    my.prefs.incrStats('threads_clicked');

    if (ts.isInBox) {
      ts.save();
    } else {
      my.prefs.incrStats('threads_visited');
      my.favs.box.put(ts.id, ts);
    }

    my.favoriteBloc.add(FavoriteUpdated());
  }

  // TODO: DRY
  int _appendPosts(List<Post> newPosts, {ThreadStorage fav, ThreadData data}) {
    data ??= getThreadData(fav.key);
    fav ??= data.threadStorage;
    int lastCounter;

    if (data != null) {
      lastCounter = data.posts.isEmpty ? 1 : data.posts.last.counter;
    }

    final List<Post> fileredPosts = [];
    for (final post in newPosts) {
      if (lastCounter != null) {
        if (int.parse(data.posts.last.outerId) < int.parse(post.outerId)) {
          lastCounter += 1;
          post.counter = lastCounter;
          fileredPosts.add(post);
        }
      }

      final myPost =
          my.posts.get("${post.platform.toString()}-${post.boardName}-${post.outerId}") as Post;
      if (myPost != null && myPost.isMine) {
        post.isMine = true;
      }

      // mark green
      for (final postId in post.repliesParent) {
        final platform = fav?.platform ?? data.thread.platform;
        final boardName = fav?.boardName ?? data.thread.boardName;
        final myPost = my.posts.get("${platform.toString()}-$boardName-$postId") as Post;
        if (myPost != null && myPost.isMine == true) {
          fav.hasReplies = true;
          fav.putOrSave();
          if (!post.isPersisted) {
            post.isToMe = true;
            post.isUnread = true;
            my.posts.put(post.toKey, post);
          }
        }

        final parentPost = data?.posts?.firstWhere((e) => e.outerId == postId, orElse: () => null);
        if (parentPost != null && !parentPost.replies.contains(post.outerId)) {
          parentPost.replies.add(post.outerId);
        }
      }
    }

    if (data == null || fileredPosts.isEmpty) {
      return 0;
    }

    data.posts = data.posts + fileredPosts;
    if (data.thread.mediaFiles != null) {
      data.thread.mediaFiles = appendMediaList(data.thread.mediaFiles, fileredPosts);
    }

    // _parseReplies(data, data.posts);

    return fileredPosts.length;
  }

  Future<void> getNewPosts({@required String threadId, @required String boardName}) async {
    assert(threadId != null && boardName != null);
    assert(_current != null);

    final startPostId = _current.posts.isEmpty ? threadId : _current.posts.last.outerId;

    final newPosts = await repo
        .on(Platform.dvach)
        .fetchNewPosts(threadId: threadId, boardName: boardName, startPostId: startPostId);

    _appendPosts(newPosts, data: _current);

    final lastId = _current.threadStorage.unreadPostId.toInt();
    for (final post in newPosts) {
      if (post.outerId.toInt() > lastId) {
        _current.threadStorage.unreadCount += 1;
      }
    }
  }

  Map<String, List<String>> _parseReplies(ThreadData threadData, List<Post> posts) {
    final Map<String, List<String>> result = {};
    if (posts == null) {
      return result;
    }

    final platform = threadData.thread.platform;
    final boardName = threadData.thread.boardName;

    final matchPost = platform == Platform.dvach ? ">>" : '&gt;&gt;';

    for (final post in posts) {
      if (my.prefs.getBool('hide_my_posts') == false) {
        final myPost = my.posts.get("${platform.toString()}-$boardName-${post.outerId}") as Post;

        // post.isMine = threadData.myPosts.any((e) => e.outerId == post.outerId);
        post.isMine = myPost?.isMine == true;
      }

      for (final postId in post.repliesParent) {
        if (result.containsKey(postId) == false) {
          result[postId] = [];
        }
        if (my.prefs.getBool('hide_my_posts') == false) {
          final myPost = my.posts.get("${platform.toString()}-$boardName-$postId") as Post;

          // final toMe = threadData.myPosts.any((e) => e.outerId == postId);
          final toMe = myPost?.isMine == true;
          if (!post.isMine && toMe) {
            final youMark = my.prefs.getString('you_mark', defaultValue: Consts.youMark);
            post.isToMe = true;

            post.body =
                post.body.replaceAll('$matchPost$postId<', '<b>$matchPost$postId </b>$youMark<');
          }
        }
        result[postId].add(post.outerId);
      }
    }

    for (final post in posts) {
      if (result.containsKey(post.outerId)) {
        post.replies = result[post.outerId];
      }
      if (post.isMine || post.isToMe) {
        my.posts.put(post.toKey, post);
      }
    }

    return result;
  }

  int postIdToIndex({String postId, int orElse}) {
    final int result = _current?.posts?.indexWhere((e) => e.outerId == postId);
    if ((result == null || result == -1) && orElse != null) {
      return orElse;
    }
    return result ?? -1;
  }

  List<Media> appendMediaList(List<Media> mediaList, List<Post> posts) {
    if (posts == null || posts.isEmpty) {
      return [];
    }

    for (final post in posts) {
      if (post.mediaFiles.isNotEmpty) {
        post.mediaFiles.forEach(mediaList.add);
      }
    }

    return mediaList;
  }

  ThreadData initThreadData(Thread thread) {
    if (_threadDataList.containsKey(thread.toKey)) {
      final result = _threadDataList[thread.toKey];
      return result;
    } else {
      return _threadDataList[thread.toKey] = ThreadData(thread: thread);
    }
  }

  ThreadData getThreadData(String key) {
    return _threadDataList[key];
    // if (_threadDataList.containsKey(key)) {
    //   return _threadDataList[key];
    // } else {
    //   return null;
    // }
  }
}
