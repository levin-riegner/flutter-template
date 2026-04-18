import 'package:color_picker/app/navigation/listener/route_listener.dart';
import 'package:color_picker/util/integrations/analytics.dart';

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
