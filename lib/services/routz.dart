import 'package:flutter/cupertino.dart';
import 'package:iChan/blocs/thread/barrel.dart';
import 'package:iChan/models/thread_storage.dart';
import 'package:iChan/models/models.dart';
import 'package:iChan/pages/board_page.dart';
import 'package:iChan/pages/thread_page.dart';
import 'package:iChan/services/exports.dart';
import 'package:iChan/services/my.dart' as my;
import 'package:iChan/widgets/fade_route.dart';

class Routz {
  Routz(this.context);
  final BuildContext context;

  static Routz of(BuildContext _context) => Routz(_context);

  void backTo(String routeName) => Navigator.popUntil(
      context, (route) => route.settings.name == routeName || route.settings.name == "/");

  void backToThread() => backTo('/thread');

  Future toPage(
    Widget page, {
    String title,
    bool fullscreen = false,
    bool replace = false,
  }) async {
    if (replace) {
      return await Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          builder: (context) => page,
          title: title,
          fullscreenDialog: fullscreen,
        ),
      );
    }
    return await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => page,
        title: title,
        fullscreenDialog: fullscreen,
      ),
    );
  }

  Future fadeToPage(Widget page, {bool replace = false, RouteSettings settings}) async {
    settings ??= const RouteSettings();
    final pageRoute = FadeRoute(page: page, settings: settings);
    if (replace) {
      return await Navigator.of(context).pushReplacement(pageRoute);
    } else {
      return await Navigator.of(context).push(pageRoute);
    }
  }

  // as thread: called from boards, loaded thread body
  // as thread link: called from links to other threads
  Future<bool> toThread(
      {Thread thread,
      ThreadLink threadLink,
      bool replace = false,
      String previousPageTitle}) async {
    assert(threadLink != null || thread != null);

    // print("Going to thread $threadLink");

    ThreadData threadData;
    if (thread != null) {
      threadData = ThreadData(thread: thread);
      threadData.status = thread.isNotEmpty ? ThreadStatus.partial : ThreadStatus.empty;
      final fav = ThreadStorage.findById(thread.toKey);

      if (fav.isNotEmpty && fav.rememberPostId != '') {
        threadData.status = ThreadStatus.empty;
      }
      if (my.threadBloc.getThreadData(thread.toKey) != null) {
        threadData.status = ThreadStatus.cached;
      }
    } else if (threadLink != null) {
      threadData = ThreadData.fromThreadLink(threadLink);
    } else {
      throw Exception("Unknown data");
    }

    final threadPage = ThreadPage(
      key: Key(threadData.thread.toKey),
      threadData: threadData,
      previousPageTitle: previousPageTitle,
    );

    final route = CupertinoPageRoute<bool>(
      builder: (context) => threadPage,
      title: thread?.trimTitle(Consts.navLeadingTrimSize),
      settings: const RouteSettings(name: ThreadPage.routeName),
    );

    if (replace) {
      return await Navigator.pushReplacement(context, route);
    } else {
      final result = await Navigator.push(context, route);
      my.threadBloc.add(ThreadClosed(threadData: threadData));
      return result;
    }
  }

  Future<bool> toBoard(Board board,
      {bool replace = false, String query = '', String previousPageTitle}) async {
    assert(board != null);

    final Route<bool> route = CupertinoPageRoute(
      builder: (context) => BoardPage(
        board: board,
        query: query,
        previousPageTitle: previousPageTitle,
      ),
      title: "/${board.id}/",
      settings: const RouteSettings(name: ThreadPage.routeName),
    );

    if (replace) {
      return await Navigator.pushReplacement(context, route);
    }

    return await Navigator.push(context, route);
  }
}
