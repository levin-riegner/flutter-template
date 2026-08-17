import 'package:swiss_ai/app/navigation/listener/route_listener.dart';
import 'package:swiss_ai/util/integrations/analytics.dart';

class AnalyticsRouteListener implements RouteListener {
  final Analytics _analytics;

  const AnalyticsRouteListener(this._analytics);

  @override
  void onRouteChanged({
    required String location,
    required String path,
    String? name,
  }) {
    _analytics.setCurrentScreen(
      name: location,
      screenClass: name,
    );
  }
}
