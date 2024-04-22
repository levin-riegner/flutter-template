import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_template/app/navigation/redirect/route_redirect.dart';
import 'package:flutter_template/app/navigation/router/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:logging_flutter/logging_flutter.dart';

class AuthRouteRedirect implements RouteRedirect {
  Future<bool> Function() hasSessionAvailable;

  // TODO: Add your auth routes here
  static const List<String> authRoutes = [
    "/login",
    "/create-account",
    "/change-password-request",
    "/change-password-request/confirm",
    "/otp",
  ];

  AuthRouteRedirect({
    required this.hasSessionAvailable,
  });

  @override
  FutureOr<String?> redirectTo(
      BuildContext context, GoRouterState state) async {
    final unauthenticatedDefaultRoute = const LoginRoute().location;

    // If the current route is an auth route, don't redirect
    if (authRoutes.contains(state.matchedLocation)) {
      return null;
    }

    if (await hasSessionAvailable()) {
      Flogger.i("User is available, continue navigation to ${state.name}");
      return null;
    } else {
      Flogger.i(
          "User is not authenticated for ${state.name}, navigating to $unauthenticatedDefaultRoute");
      return unauthenticatedDefaultRoute;
    }
  }
}
