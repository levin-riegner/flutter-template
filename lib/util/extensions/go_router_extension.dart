import 'package:go_router/go_router.dart';

// Source: https://github.com/flutter/flutter/issues/129833
extension GoRouterExtension on GoRouter {
  RouteMatchList _currentMatchList() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    return lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
  }

  Uri location() {
    return _currentMatchList().uri;
  }

  String fullPath() {
    return _currentMatchList().fullPath;
  }

  String? routeName() {
    final route = _currentMatchList().last.route;
    return route.name;
  }
}
