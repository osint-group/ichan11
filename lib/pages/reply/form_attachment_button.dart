import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iChan/blocs/post_bloc.dart';
import 'package:iChan/models/thread.dart';
import 'package:iChan/services/my.dart' as my;

class FormAttachmentButtons extends StatelessWidget {
  const FormAttachmentButtons({
    Key key,
    @required this.thread,
  }) : super(key: key);

  final Thread thread;

  @override
  Widget build(BuildContext context) {
    final iconSize = my.contextTools.isVerySmallHeight ? 20.0 : 24.0;

    return Row(
      children: <Widget>[
        CupertinoButton(
          child: FaIcon(FontAwesomeIcons.images, size: iconSize),
          onPressed: () async {
            my.postBloc.add(AddFiles(
                files: await FilePicker.getMultiFile(type: FileType.media)));
          },
        ),
        CupertinoButton(
          child: FaIcon(FontAwesomeIcons.file, size: iconSize),
          onPressed: () async {
            my.postBloc.add(AddFiles(
                files: await FilePicker.getMultiFile(type: FileType.any)));
          },
        ),
      ],
    );
  }
}
