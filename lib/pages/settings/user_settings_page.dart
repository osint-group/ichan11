import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iChan/services/consts.dart';
import 'package:iChan/services/exports.dart';
import 'package:iChan/widgets/menu/menu.dart';
import 'package:iChan/services/my.dart' as my;

class UserSettingsPage extends StatelessWidget {
  final TextEditingController albumController = TextEditingController();

  static const header = 'Stats';

  Future<Map> getData() async {
    final posts = await my.db.getMyPosts();
    return {'posts': posts};
  }

  Widget build(BuildContext context) {
    // final threads = my.favs.box.values;
    // final threadsVisited = threads.length;
    // final threadsCreated =
    // threads.where((e) => e.opCookie?.isNotEmpty == true).length;

    // final threadsClicked = threads.sumBy((e) => e?.visits ?? 0);

    final Map<String, int> stats = my.prefs.stats;

    return HeaderNavbar(
      backgroundColor: my.theme.secondaryBackgroundColor,
      middleText: header,
      previousPageTitle: "Settings",
      child: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              padding: const EdgeInsets.only(top: Consts.topPadding * 3),
              children: [
                MenuTextField(
                  label: "Threads visited",
                  value: stats['threads_visited'].toString(),
                ),
                MenuTextField(
                  label: "Total threads clicked",
                  value: stats['threads_clicked'].toString(),
                ),
                MenuTextField(
                  label: "Threads created",
                  value: stats['threads_created'].toString(),
                ),
                MenuTextField(
                  label: "Posts created",
                  // value: snapshot.data['posts']?.length?.toString(),
                  value: stats['posts_created'].toString(),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
