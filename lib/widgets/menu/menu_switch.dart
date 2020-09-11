import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iChan/pages/thread/thread.dart';
import 'package:iChan/services/consts.dart';
import 'package:iChan/services/my.dart' as my;

class MenuSwitch extends StatelessWidget {
  const MenuSwitch({
    @required this.label,
    @required this.field,
    this.defaultValue,
    this.onChanged,
    this.isFirst = false,
    this.isLast = false,
    this.enabled = true,
  });

  final String label;
  final String field;
  final bool defaultValue;
  final Function(bool) onChanged;
  final bool isFirst;
  final bool isLast;
  final bool enabled;

  Border makeBorder() {
    if (isFirst) {
      return Border(top: BorderSide(color: my.theme.navBorderColor));
    } else if (isLast) {
      return Border.symmetric(vertical: BorderSide(color: my.theme.navBorderColor));
    } else {
      return Border(top: BorderSide(color: my.theme.navBorderColor));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Consts.menuItemHeight,
      padding: const EdgeInsets.symmetric(horizontal: Consts.sidePadding * 1.5),
      decoration: BoxDecoration(color: my.theme.backgroundMenuColor, border: makeBorder()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                color: enabled
                    ? my.theme.foregroundBrightColor
                    : my.theme.foregroundBrightColor.withOpacity(0.5),
              )),
          ValueListenableBuilder(
            valueListenable: my.prefs.box.listenable(keys: [field]),
            builder: (context, box, widget) {
              return CupertinoSwitch(
                  value: box.get(field, defaultValue: defaultValue) as bool,
                  onChanged: (val) {
                    if (!enabled) {
                      return;
                    }

                    if (onChanged == null) {
                      box.put(field, val);
                    } else {
                      final result = onChanged(val);
                      if (result != false) {
                        box.put(field, val);
                      }
                    }
                  });
            },
          ),
        ],
      ),
    );
  }
}
