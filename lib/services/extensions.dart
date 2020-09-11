import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';

String numToPluralKey(num val) {
  final p10 = val % 10;
  final p100 = val % 100;

  if (p10 == 1 && p100 != 11) {
    return 'one';
  } else if ([2, 3, 4].contains(p10) && ![12, 13, 14].contains(p100)) {
    return 'few';
  } else if (p10 == 0 || [5, 6, 7, 8, 9].contains(p10) || [11, 12, 13, 14].contains(p100)) {
    return 'many';
  }
  return 'other';
}

extension StringExtension on String {
  String get presence {
    if (this == null || isEmpty) {
      return null;
    } else {
      return this;
    }
  }

  String plur(num val) {
    final key = numToPluralKey(val);
    return '$this.$key'.tr(args: [val.toString()]);
  }

  bool get blank => this == null || isEmpty;
  bool get present => !blank;
}

extension ListPresence<T> on List<T> {
  List<T> get presence {
    if (this == null || isEmpty) {
      return null;
    } else {
      return this;
    }
  }

  bool get blank => this == null || isEmpty;
  bool get present => !blank;
}

extension Screen on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;
}
