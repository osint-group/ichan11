import 'package:flutter/cupertino.dart';
import 'package:iChan/services/exports.dart';
import 'package:iChan/services/my.dart' as my;
import 'package:iChan/widgets/shimmer_widget.dart';

class TapToReload extends StatelessWidget {
  TapToReload({Key key, this.message, this.onTap}) : super(key: key);

  final Function onTap;
  final String message;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  // double value = 0.0;
  static const defaultMessage = 'Error.';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
          onTap: () async {
            if (onTap != null) {
              isLoading.value = true;
              await Future.delayed(2.seconds);
              onTap();
              isLoading.value = false;
            }
          },
          child: ValueListenableBuilder(
              valueListenable: isLoading,
              builder: (context, val, snapshot) {
                if (val == true) {
                  return const ShimmerLoader();
                } else {
                  return Center(
                      child: Text(
                    '${message ?? defaultMessage}\nTap to reload.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: my.theme.primaryColor,
                      fontSize: Consts.errorLoadingTextSize,
                    ),
                  ));
                }
              })),
    );
  }
}
