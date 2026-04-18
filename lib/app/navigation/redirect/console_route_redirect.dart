import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:color_picker/app/navigation/redirect/route_redirect.dart';
import 'package:color_picker/app/navigation/router/app_routes.dart';
import 'package:go_router/go_router.dart';

class ConsoleRouteRedirect implements RouteRedirect {
  final bool internalBuild;

  const ConsoleRouteRedirect({
    required this.internalBuild,
  });

  @override
  FutureOr<String?> redirectTo(
    BuildContext context,
    GoRouterState state,
  ) {
    if (state.matchedLocation.startsWith(const ConsoleRoute().location) &&
        internalBuild) {
      // Redirect console to default location if not allowed
      return "/";
    }
    return null;
  }
}
