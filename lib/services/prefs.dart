import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:iChan/models/platform.dart';
import 'package:iChan/services/box_proxy.dart';

import 'exports.dart';
import 'helper.dart';

class PrefsBox extends BoxProxy {
  PrefsBox({this.box});

  final Box box;

  final defaultStats = {
    "threads_visited": 0,
    "threads_clicked": 0,
    "threads_created": 0,
    "posts_created": 0,
    "visits": 0,
  };

  bool get isTranslucent => !getBool('classic_mode');

  bool get isTester => getBool('tester');
  bool get isClassic => getBool('classic_mode');

  ScrollPhysics get scrollPhysics => const BouncingScrollPhysics();

  double get postFontSize => double.parse(box.get('post_font_size', defaultValue: "15") as String);

  bool get showCaptcha => getBool('passcode_enabled') == false;

  bool get passcodeOn => getBool('passcode_enabled');
  bool get passcodeOff => !passcodeOn;

  List<Platform> get platforms => (get('platforms') ?? []).cast<Platform>();

  FontWeight get fontWeight {
    final val = box.get('light_font', defaultValue: false) as bool;
    return val ? FontWeight.w300 : FontWeight.normal;
  }

  String get usercookie {
    final existing = getString('cookie_usercode');
    if (existing.isEmpty) {
      final code = Helper.generateUsercode();
      box.put('cookie_usercode', code);
      return code;
    } else {
      return existing;
    }
  }

  void incrStats(String field, {int to = 1}) {
    final Map<String, int> stats = Map.from(get("stats", defaultValue: defaultStats));
    stats[field] ??= 0;
    stats[field] += to;
    put("stats", stats);
  }

  void setStats(String field, int val) {
    final Map<String, int> stats = Map.from(get("stats", defaultValue: defaultStats));
    stats[field] = val;
    put("stats", stats);
  }

  Map<String, int> get stats => Map<String, int>.from(get('stats', defaultValue: defaultStats));

  String getJsonCache(String key) {
    final cache = get('json_cache', defaultValue: {}).cast<String, String>();
    return cache[key] ?? '';
  }

  void putJsonCache(String key, String value) {
    final cache = get('json_cache', defaultValue: {}).cast<String, String>();
    cache[key] = value;
    put('json_cache', cache);
  }
}
