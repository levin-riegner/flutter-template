import 'package:flutter/widgets.dart';
import 'package:flutter_template/app/navigation/redirect/route_redirect.dart';
import 'package:flutter_template/app/navigation/router/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:logging_flutter/logging_flutter.dart';

abstract class AppRouterBuilder {
  const AppRouterBuilder._();

  static GoRouter buildRouter({
    GlobalKey<NavigatorState>? rootNavigatorKey,
    List<RouteRedirect> redirects = const [],
    String? initialLocation,
  }) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: initialLocation,
      // Logs are already captured by logging_flutter using the "GoRouter" logger name
      debugLogDiagnostics: false,
      onException: (context, state, router) {
        Flogger.w(
            "GoRouterException for location ${state.uri} with error: ${state.error}");
        router.go("/");
      },
      redirect: (context, state) {
        for (final redirect in redirects) {
          final redirectPath = redirect.redirectTo(context, state);
          if (redirectPath != null) {
            return redirectPath;
          }
        }
        return null;
      },
      routes: $appRoutes,
    );
  }
}
