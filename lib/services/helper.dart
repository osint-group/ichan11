import 'dart:convert';
import 'dart:math';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:crypto/crypto.dart';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:iChan/repositories/2ch/makaba_api.dart';
import 'package:iChan/services/exports.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:iChan/services/my.dart' as my;

class Helper {
  static String takeFirst(String text, int number, {String dots}) {
    if (text == null) {
      return "n/a";
    } else if (text.length <= number) {
      return text;
    } else {
      String result = text.substring(0, number);
      if (dots != null) {
        result = "${result.trim()}$dots";
      }
      return result;
    }
  }

  static void cleanCache() {
    FilePicker.clearTemporaryFiles();
    my.cacheManager.emptyCache();
    clearDiskCachedImages();
  }

  static void cleanJsonCache() {
    my.prefs.put('json_cache', {});
  }

  static String presence(String obj) {
    if (obj == null || obj.isEmpty) {
      return null;
    } else {
      return obj;
    }
  }

  static String formatDate(int timestamp, {bool year = true, bool compact = false}) {
    // final current = DateTime.now();
    // final diff = timeDiffInSeconds(timestamp);
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String str;

    if (compact) {
      if (timeDiffInSeconds(timestamp) <= 24 * 3600) {
        str = 'HH:mm';
      } else {
        str = 'dd.MM.yy';
      }
    } else {
      str = year ? 'dd.MM.yy HH:mm' : 'dd.MM HH:mm';
    }
    return DateFormat(str).format(date).toString();
  }

  static String timestampToHuman(int timestamp, {bool year = true, bool compact = false}) {
    // final messages = RuMessages();
    final elapsed = DateTime.now().millisecondsSinceEpoch - timestamp;

    final suffix = 'ago'.tr();

    final num seconds = elapsed / 1000;
    final num minutes = seconds / 60;
    final num hours = minutes / 60;

    final keys = compact
        ? {'min': 'date.compact_minute', 'hour': 'date.compact_hour'}
        : {'min': 'date.minute', 'hour': 'date.hour'};

    String result;
    if (seconds < 10) {
      return 'now'.tr();
    } else if (seconds < 45) {
      // result = messages.lessThanOneMinute(seconds.round());
      result = keys['min'].plur(1);
    } else if (seconds < 90) {
      result = keys['min'].plur(1);
    } else if (minutes <= 60) {
      result = keys['min'].plur(minutes.round());
    } else if (hours < 24) {
      final wholeHours = minutes ~/ 60;
      final minutesLeft = (minutes - wholeHours * 60).round();
      if (minutesLeft <= 30) {
        result = keys['hour'].plural(wholeHours);
      } else {
        result = keys['hour'].plural(wholeHours + 1);
      }
    } else {
      return formatDate(timestamp, year: year, compact: compact);
    }

    return [result, suffix].where((str) => str != null && str.isNotEmpty).join(' ');
  }

  static Future<bool> launchUrl(String url) async {
    if (await canLaunch(url)) {
      return await launch(url);
    } else {
      return Future.value(false);
    }
  }

  static int timeDiff(int ms) => DateTime.now().millisecondsSinceEpoch - ms;

  static int timeDiffInSeconds(int ms) => timeDiff(ms) ~/ 1000;

  static String generateUsercode() {
    final random = Random.secure();
    final value = random.nextInt(1000).toString();
    final randomcode = sha256.convert(utf8.encode(value)).toString();
    return randomcode.substring(0, 64);
  }

  static Map<String, String> headersForPath(String path) {
    final cookieJar = PersistCookieJar(dir: Consts.appDocDir.path);

    final uri = Uri.https("2ch.hk", '/');
    final cookies = cookieJar.loadForRequest(uri);
    final usercodeCookie = cookies.firstWhere((e) => e.name == 'usercode_auth', orElse: () => null);

    if (usercodeCookie != null) {
      return {'cookie': '${usercodeCookie.name}=${usercodeCookie.value}'};
    } else {
      return {'cookie': MakabaApi.nsfwCookie};
    }
  }

  static Future<void> setAutoturn(String mode) async {
    switch (mode) {
      case "portrait":
        return await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      case "landscape":
        return await SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
      case "auto":
        return await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ]);
    }
  }
}
