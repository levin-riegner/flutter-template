import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_template/app/navigation/redirect/route_redirect.dart';
import 'package:go_router/go_router.dart';
import 'package:logging_flutter/logging_flutter.dart';

class AuthRouteRedirect implements RouteRedirect {
  final String unauthenticatedDefaultRoute;
  final Future<bool> Function() hasSessionAvailable;

  // TODO: Add your auth routes here
  static const List<String> authRoutes = [
    "/login",
    "/create-account",
    "/create-account/verify",
    "/change-password",
    "/change-password/confirm",
    "/reset-password",
    "/reset-password/confirm",
    "/otp",
  ];

  const AuthRouteRedirect({
    required this.unauthenticatedDefaultRoute,
    required this.hasSessionAvailable,
  });

  @override
  FutureOr<String?> redirectTo(
      BuildContext context, GoRouterState state) async {
    // If the current route is an auth route, don't redirect
    if (authRoutes.contains(state.matchedLocation)) {
      return null;
    }

    if (await hasSessionAvailable()) {
      return null;
    } else {
      Flogger.i(
          "User is not authenticated for ${state.name}, navigating to $unauthenticatedDefaultRoute");
      return unauthenticatedDefaultRoute;
    }
  }
}
