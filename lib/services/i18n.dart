// import 'package:easy_localization/easy_localization.dart';
// import 'extensions.dart';

// abstract class LookupMessages {
//   String prefixAgo();
//   String prefixFromNow();
//   String suffixAgo();
//   String suffixFromNow();
//   String rightNow();
//   String lessThanOneMinute(int seconds);
//   String aboutAMinute(int minutes);
//   String minutes(int minutes);
//   String hoursAndMinutes(int hours, int minutes);
//   String aboutAnHour(int minutes);
//   String hours(int hours);
//   String aDay(int hours);
//   String days(int days);
//   String aboutAMonth(int days);
//   String months(int months);
//   String aboutAYear(int year);
//   String years(int years);
//   String wordSeparator() => ' ';
// }

// class RuMessages implements LookupMessages {
//   @override
//   String prefixAgo() => '';
//   @override
//   String prefixFromNow() => 'after'.tr();
//   @override
//   String suffixAgo() => 'ago'.tr();
//   @override
//   String suffixFromNow() => '';
//   @override
//   String rightNow() => 'now'.tr();
//   @override
//   String lessThanOneMinute(int seconds) => 'date.minute'.tr();
//   @override
//   String aboutAMinute(int minutes) => 'date.minute'.plur(1);
//   @override
//   String minutes(int minutes) => "$minutes ${_convert(minutes, 'minute')}";
//   @override
//   String hoursAndMinutes(int hours, int minutes) {
//     final primary = _convert(hours, 'date.hour');
//     return '$hours $primary $minutes ${_convert(minutes, 'minute')}';
//   }

//   @override
//   String aboutAnHour(int minutes) => 'date.hour'.tr();
//   @override
//   String hours(int hours) => "$hours ${_convert(hours, 'hour')}";
//   @override
//   String aDay(int hours) => 'date.day'.tr();
//   @override
//   String days(int days) => _convert(days, 'date.day');
//   @override
//   String aboutAMonth(int days) => 'date.month'.tr();
//   @override
//   String months(int months) => _convert(months, 'date.month');
//   @override
//   String aboutAYear(int year) => 'date.year'.tr();
//   @override
//   String years(int years) => 'date.year'.plur(years);
//   @override
//   String wordSeparator() => ' ';
// }
