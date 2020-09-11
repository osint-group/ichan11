import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iChan/blocs/thread/barrel.dart';
import 'package:iChan/services/exports.dart';
import 'package:iChan/services/my.dart' as my;

import 'thread.dart';

class PostReplies extends StatelessWidget {
  const PostReplies({
    Key key,
    this.replies,
    this.threadData,
    this.highlightPostId = '',
  }) : super(key: key);
  final List<Post> replies;
  final ThreadData threadData;
  final String highlightPostId;

  @override
  Widget build(BuildContext context) {
    final isCentered = my.prefs.getBool("replies_on_center");

    return HeaderNavbar(
      backgroundColor: my.theme.secondaryBackgroundColor,
      transparent: true,
      child: SafeArea(
        bottom: false,
        top: false,
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity >= Consts.verticalGestureVelocity) {
              Routz.of(context).backToThread();
            }
          },
          child: Container(
            color: my.theme.backgroundColor,
            alignment: isCentered ? Alignment.center : Alignment.topCenter,
            child: ListView.builder(
              shrinkWrap: true,
              physics: my.prefs.scrollPhysics,
              itemCount: replies.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    if (index != 0) Divider(color: my.theme.dividerColor, height: 1),
                    PostItem(
                      origin: Origin.reply,
                      post: replies[index],
                      threadData: threadData,
                      highlightPostId: highlightPostId,
                    ),
                    if (index != replies.length - 2)
                      Divider(color: my.theme.dividerColor, height: 1)
                  ],
                );
              },
            ),
          ),
        ),
      ),
      // middleText: "Replies",
      trailing: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Routz.of(context).backToThread();
        },
        child: const Icon(CupertinoIcons.clear_thick),
      ),
    );
  }
}
