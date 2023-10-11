import 'dart:ui';

import 'package:flutter_template/app/navigation/listener/route_listener.dart';
import 'package:flutter_template/app/navigation/router/app_routes.dart';
import 'package:flutter_template/presentation/shared/adaptive_theme/adaptive_theme_cubit.dart';

class ThemeRouteListener implements RouteListener {
  final AdaptiveThemeCubit _themeCubit;

  const ThemeRouteListener(this._themeCubit);

  @override
  void onRouteChanged({
    required String location,
    required String path,
    String? name,
  }) {
    final brightness = AppRouteData.fromFullPath(path).brightness;
    switch (brightness) {
      case Brightness.light:
        _themeCubit.setLightTheme();
        break;
      case Brightness.dark:
        _themeCubit.setDarkTheme();
        break;
    }
  }
}
