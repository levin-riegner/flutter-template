import 'package:flutter/widgets.dart';
import 'package:flutter_template/util/integrations/analytics.dart';

class ScreenNameObserver extends RouteObserver<PageRoute<dynamic>> {
  /// Creates a [NavigatorObserver] that sends screen names to [Analytics].

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute && route.settings.name != null) {
      Analytics.setCurrentScreenName(route.settings.name!);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute && newRoute.settings.name != null) {
      Analytics.setCurrentScreenName(newRoute.settings.name!);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && previousRoute.settings.name != null) {
      Analytics.setCurrentScreenName(previousRoute.settings.name!);
    }
  }
}
