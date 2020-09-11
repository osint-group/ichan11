import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iChan/services/my.dart' as my;

import 'form_tag_buttons.dart';

class FormMoveableButtons extends StatelessWidget {
  const FormMoveableButtons({Key key, this.controller, this.position}) : super(key: key);

  final TextEditingController controller;
  final String position;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: my.prefs.box.listenable(keys: ['markup_on_bottom']),
      builder: (context, box, child) {
        final isBottom = my.prefs.getBool('markup_on_bottom');
        if (isBottom ? position != "bottom" : position != "top") {
          return Container();
        }
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity >= 200) {
              if (!isBottom) {
                my.prefs.put('markup_on_bottom', true);
              }
            } else if (details.primaryVelocity <= -200) {
              if (isBottom) {
                my.prefs.put('markup_on_bottom', false);
              }
            }
          },
          child: Padding(
            padding: EdgeInsets.only(top: isBottom ? 5.0 : 0.0, bottom: isBottom ? 0.0 : 5.0),
            child: FormTagButtonsRow(controller: controller),
          ),
        );
      },
    );
  }
}
