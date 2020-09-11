import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:iChan/services/consts.dart';
import 'package:iChan/services/my.dart' as my;

class BlurFilter extends StatelessWidget {
  const BlurFilter({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!my.prefs.isTranslucent) {
      return child;
    }

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ),
        child: Opacity(opacity: Consts.navbarOpacity, child: child),
      ),
    );
  }
}
