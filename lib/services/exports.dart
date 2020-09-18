import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:iChan/services/consts.dart';

export 'dart:developer';

export 'package:easy_localization/easy_localization.dart';
export 'package:supercharged/supercharged.dart';

export '../ui/context_tools.dart';
export '../ui/haptic.dart';
export '../ui/interactive.dart';
export '../widgets/header_navbar.dart';
export 'box_proxy.dart';
export 'consts.dart';
export 'enums.dart';
export 'exceptions.dart';
export 'extensions.dart';
export 'log.dart';
export 'profiler.dart';
export 'routz.dart';
export 'system.dart';

bool get isIos => foundation.defaultTargetPlatform == TargetPlatform.iOS;
bool get isDebug => !Consts.isPhysical || foundation.kDebugMode;
// bool get isDebug => false;
// bool get isTest => DotEnv().env["FLUTTER_ENV"] == "test";
bool get isProd => !isDebug;
