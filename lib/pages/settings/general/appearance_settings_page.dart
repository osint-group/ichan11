import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iChan/pages/settings/general_links_page.dart';
import 'package:iChan/services/consts.dart';
import 'package:iChan/services/exports.dart';
import 'package:iChan/widgets/menu/menu.dart';
import 'package:iChan/services/my.dart' as my;

class AppearanceSettingsPage extends StatelessWidget {
  static const header = 'Appearance';

  @override
  Widget build(BuildContext context) {
    return HeaderNavbar(
      backgroundColor: my.theme.secondaryBackgroundColor,
      previousPageTitle: GeneralSettingsPage.header,
      middleText: header,
      child: ListView(
        padding: const EdgeInsets.only(top: Consts.topPadding * 3),
        children: [
          const MenuSwitch(
            label: "Classic design",
            field: "classic_mode",
            defaultValue: false,
            isFirst: true,
          ),
          const MenuSwitch(
            label: 'Disable activity',
            field: 'activity_disabled',
            defaultValue: false,
          ),
          const MenuSwitch(
            label: 'Disable history',
            field: 'history_disabled',
            defaultValue: false,
          ),
          menuDivider,
          const MenuSwitch(
              label: "Replies on center", field: "replies_on_center", defaultValue: false),
          const MenuSwitch(
              label: "Disable autoturn in threads", field: "disable_autoturn", defaultValue: false),
          const MenuSwitch(
              label: "Show absolute time", field: "absolute_time", defaultValue: false),
          const MenuSwitch(
              label: "Do not mark my posts", field: "hide_my_posts", defaultValue: false),
          const MenuSwitch(
            label: 'Do not fav on reply',
            field: 'fav_on_reply_disabled',
            defaultValue: false,
          ),
          const MenuSwitch(
            label: 'Do not close replies on reply',
            field: 'back_to_thread_disabled',
            defaultValue: false,
          ),
          if (Consts.isIpad) ...[
            const MenuSwitch(label: "Menu on the right", field: "right_menu", defaultValue: false),
            const MenuSwitch(
              label: "Menu on the bottom",
              field: "bottom_menu",
              defaultValue: false,
              isLast: true,
            )
          ],
        ],
      ),
    );
  }
}
