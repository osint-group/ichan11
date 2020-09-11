import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iChan/pages/thread/thread.dart';
import 'package:iChan/services/consts.dart';
import 'package:iChan/ui/haptic.dart';
import 'package:iChan/services/my.dart' as my;

class MenuTextField extends StatefulWidget {
  const MenuTextField({
    this.key,
    this.label,
    this.boxField,
    this.value = '',
    this.onTap,
    this.onChanged,
    this.enabled = true,
    this.isFirst = false,
    this.isLast = false,
    this.fontSize = 17.0,
    this.keyboardType = TextInputType.text,
  });

  final Key key;
  final String label;
  final String boxField;
  final String value;
  final bool enabled;
  final bool isFirst;
  final bool isLast;
  final Function onChanged;
  final TextInputType keyboardType;
  final double fontSize;
  final Function onTap;

  @override
  MenuTextFieldState createState() => MenuTextFieldState();
}

class MenuTextFieldState extends State<MenuTextField> {
  bool isEdit = false;
  final controller = TextEditingController();
  bool readonly;

  @override
  void initState() {
    readonly = widget.boxField == null;
    // TODO: implement initState
    super.initState();
  }

  Border makeBorder() {
    if (widget.isFirst) {
      return Border(top: BorderSide(color: my.theme.navBorderColor));
    } else if (widget.isLast) {
      return Border.symmetric(vertical: BorderSide(color: my.theme.navBorderColor));
    } else {
      return Border(top: BorderSide(color: my.theme.navBorderColor));
    }
  }

  @override
  Widget build(BuildContext context) {
    final val = widget.boxField != null
        ? my.prefs.get(widget.boxField, defaultValue: widget.value).toString()
        : widget.value;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap();
          return;
        }
        if (!widget.enabled || readonly) {
          return;
        }
        setState(() {
          Haptic.mediumImpact();
          isEdit = true;
        });
      },
      child: Container(
        height: Consts.menuItemHeight,
        padding: const EdgeInsets.symmetric(horizontal: Consts.sidePadding * 1.5),
        decoration: BoxDecoration(
          color: my.theme.backgroundMenuColor,
          border: makeBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isEdit) ...[
              Expanded(
                child: _MenuEditField(
                  label: widget.label,
                  field: widget.boxField,
                  defaultValue: val,
                  controller: controller,
                  onChanged: (val) {
                    if (widget.onChanged != null) {
                      widget.onChanged(val);
                    } else {
                      my.prefs.put(widget.boxField, val);
                    }
                  },
                  onEditingComplete: () {
                    setState(() {
                      isEdit = false;
                    });
                  },
                ),
              )
            ],
            if (!isEdit) ...[
              Text(widget.label,
                  style: TextStyle(
                      color: widget.enabled
                          ? my.theme.foregroundMenuColor
                          : my.theme.foregroundMenuColor.withOpacity(0.5))),
              const SizedBox(
                width: 20.0,
              ),
              Flexible(
                child: Text(
                  val.toString(),
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: my.theme.postInfoFontColor,
                    fontSize: widget.fontSize,
                  ),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}

class _MenuEditField extends StatelessWidget {
  const _MenuEditField({
    this.key,
    this.label,
    this.field,
    this.controller,
    this.readOnly = false,
    this.onChanged,
    this.defaultValue,
    this.onEditingComplete,
    this.keyboardType,
    this.enabled = true,
  });

  final Key key;
  final String label;
  final String field;
  final String defaultValue;
  final TextEditingController controller;
  final bool readOnly;
  final bool enabled;
  final Function onChanged;
  final Function onEditingComplete;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    final initialVal = my.prefs.get(field) ?? defaultValue;
    controller?.text = initialVal.toString();

    return CupertinoTextField(
      key: key,
      controller: controller,
      autofocus: true,
      decoration: BoxDecoration(
        color: my.theme.backgroundMenuColor,
      ),
      // clearButtonMode: OverlayVisibilityMode.editing,

      suffix: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          my.prefs.put(field, initialVal);
          onEditingComplete();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Icon(
            CupertinoIcons.clear_thick_circled,
            size: 18.0,
            color: CupertinoDynamicColor.resolve(my.theme.clearButtonColor, context),
          ),
        ),
      ),
      keyboardAppearance: Consts.keyboardAppearance,
      keyboardType: keyboardType,
      readOnly: readOnly,
      enabled: controller != null,
      placeholder: label,
      style: TextStyle(
        color: my.theme.editFieldContrastingColor.withOpacity(0.8),
      ),
      onChanged: (val) {
        if (onChanged == null) {
          my.prefs.put(field, val);
        } else {
          onChanged(val);
        }
      },
      onEditingComplete: () {
        if (onEditingComplete != null) {
          onEditingComplete();
        }
      },
    );
  }
}
