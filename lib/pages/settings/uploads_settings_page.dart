import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iChan/services/consts.dart';
import 'package:iChan/services/exports.dart';
import 'package:iChan/widgets/menu/menu.dart';
import 'package:iChan/services/my.dart' as my;

class UploadsSettingsPage extends StatefulWidget {
  static const header = 'Uploads';

  @override
  _UploadsSettingsPageState createState() => _UploadsSettingsPageState();
}

class _UploadsSettingsPageState extends State<UploadsSettingsPage> {
  final TextEditingController albumController = TextEditingController();

  void fieldChanged(String field, String val) {
    int parsedVal;
    try {
      parsedVal = int.parse(val);
      if (parsedVal <= 0) {
        parsedVal = 0;
      } else if (parsedVal >= 10000) {
        parsedVal = 10000;
      }
    } catch (e) {
      parsedVal = 2048;
    }

    my.prefs.put(field, parsedVal);
  }

  Widget build(BuildContext context) {
    return HeaderNavbar(
      backgroundColor: my.theme.secondaryBackgroundColor,
      middleText: UploadsSettingsPage.header,
      previousPageTitle: "Settings",
      child: ListView(
        padding: const EdgeInsets.only(top: Consts.topPadding * 3),
        children: [
          const MenuSwitch(
            label: 'Clean EXIF',
            field: 'clean_exif',
          ),
          menuDivider,
          MenuSwitch(
            label: "Compress images",
            field: "compress_images",
            defaultValue: true,
            onChanged: (val) {
              if (val == false) {
                my.prefs.put('convert_png_to_jpg', false);
              }
              setState(() {});
            },
          ),
          MenuSwitch(
            label: "Convert PNG to JPG",
            field: "convert_png_to_jpg",
            enabled: my.prefs.getBool('compress_images'),
            onChanged: (_) {
              setState(() {});
            },
          ),
          MenuTextField(
            label: "Max resolution",
            boxField: "compress_image_resolution",
            keyboardType: TextInputType.number,
            enabled: my.prefs.getBool('compress_images'),
            onChanged: (String val) {
              fieldChanged("compress_image_resolution", val);
              return false;
            },
          ),
          menuDivider,
          Container(
            height: 200.0,
            child: MenuSelect(
              field: "compress_quality",
              defaultValue: "very_high",
              enabled: my.prefs.getBool('compress_images'),
              labels: const [
                "Very high quality",
                "High quality",
                "Medium quality",
              ],
              values: const [
                "very_high",
                "high",
                "medium",
              ],
            ),
          ),
        ],
      ),
    );
  }
}
