import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/app/navigation/routes.dart';
import 'package:flutter_template/app/util/flogger.dart';

class Router {

  Route generate(RouteSettings settings) {
    Flogger.info("Navigating to ${settings.name}");
    switch (settings.name) {
      case Routes.feed:
      // TODO: return _route(settings, FeedPage());
      default:
      // TODO: return _route(settings, LandingPage());
    }
  }

  Route _route(RouteSettings settings, Widget widget,
      {bool presentModally = false}) {
    return Platform.isIOS
        ? CupertinoPageRoute(
            settings: settings,
            builder: (_) => widget,
            fullscreenDialog: presentModally,
          )
        : MaterialPageRoute(
            settings: settings,
            builder: (_) => widget,
            fullscreenDialog: presentModally,
          );
  }
}
