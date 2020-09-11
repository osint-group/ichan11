import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FadeRoute extends PageRouteBuilder {
  FadeRoute({this.page, this.settings})
      : super(
          settings: settings,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );

  final Widget page;
  final RouteSettings settings;

  @override
  final bool opaque = false;
}
