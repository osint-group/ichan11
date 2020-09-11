import 'dart:ui';

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:iChan/services/exports.dart';
import 'package:iChan/services/prefs.dart';
import 'package:iChan/ui/themes.dart';

class ThemeManager {
  ThemeManager({this.prefs});
  final PrefsBox prefs;

  String currentTheme = 'dark';

  static final themes = {
    'orange_white': OrangeWhiteTheme(),
    'black_white': BlackWhiteTheme(),
    'dark_green': DarkGreenTheme(),
    'dark': DarkTheme(),
  };

  MyTheme get theme {
    return themes[currentTheme];
  }

  void updateTheme() {
    currentTheme = prefs.getString('theme', defaultValue: 'dark');
    if (!isIos) {
      final color = theme.navbarBackgroundColor.withOpacity(Consts.navbarOpacity);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: color));
    }
  }

  void syncTheme() {
    final syncTheme = prefs.getBool('sync_theme');
    if (syncTheme) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      if (theme.brightness != brightness) {
        if (brightness == Brightness.light) {
          prefs.put('theme', 'orange_white');
        } else {
          prefs.put("theme", 'dark');
        }
        updateTheme();
      }
    }
  }
}
