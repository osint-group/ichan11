import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iChan/pages/settings/platforms_links_page.dart';
import 'package:iChan/services/exports.dart';
import 'package:iChan/widgets/menu/menu.dart';
import 'package:iChan/services/my.dart' as my;

class DvachSettingsPage extends StatelessWidget {
  final passcodeCtrl = TextEditingController();
  final domainCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  String setDomain(String domain) {
    final result = domain
        .replaceAll('www.', '')
        .replaceAll('http://', '')
        .replaceAll('https://', '')
        .replaceAll('/', '');

    return "https://$result";
  }

  @override
  Widget build(BuildContext context) {
    return HeaderNavbar(
      backgroundColor: my.theme.secondaryBackgroundColor,
      previousPageTitle: PlatformsLinksPage.header,
      middleText: '2ch',
      child: Container(
        height: context.screenHeight,
        child: ListView(
          children: [
            menuDivider,
            MenuSwitch(
              label: 'Enabled',
              field: 'dvach_enabled',
              defaultValue: false,
              onChanged: (val) {
                final List<Platform> platforms = my.prefs.platforms;

                if (val == true) {
                  const actions = [ActionSheet(text: "Use as default platform", value: "default")];
                  Interactive(context).modal(actions).then((val) {
                    if (val == 'default') {
                      platforms.insert(0, Platform.dvach);
                    } else {
                      platforms.add(Platform.dvach);
                    }
                    my.prefs.put('platforms', platforms.toSet().toList());
                    my.categoryBloc.setPlatform();
                  });
                } else {
                  platforms.remove(Platform.dvach);
                  my.prefs.put('platforms', platforms);
                }
                my.categoryBloc.setPlatform();
              },
            ),
            MenuTextField(
              label: 'Domain',
              boxField: 'domain',
              onChanged: (val) {
                if (val.isEmpty) {
                  my.prefs.put('domain', Consts.domain2ch);
                  my.makabaApi.domain = setDomain(Consts.domain2ch);
                } else {
                  my.prefs.put('domain', val);
                  my.makabaApi.domain = setDomain(val);
                  my.prefs.delete('json_cache');
                }
                my.categoryBloc.fetchBoards(Platform.dvach);
              },
            ),
            menuDivider,
            MenuSwitch(
              label: 'Passcode',
              field: 'passcode_enabled',
              defaultValue: false,
              onChanged: (v) {
                if (v == true) {
                  my.prefs.put('bypass_captcha', false);
                }
                my.prefs.put('passcode_enabled', v);
                my.contextTools.init(context);
                return false;
              },
            ),
            ValueListenableBuilder(
              valueListenable: my.prefs.box.listenable(keys: ['passcode_enabled']),
              builder: (BuildContext context, dynamic value, Widget child) {
                if (my.prefs.getBool('passcode_enabled')) {
                  return const MenuTextField(
                    label: 'Code',
                    boxField: 'passcode',
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
