import 'dart:ui';

enum AdaptiveThemeState {
  light._(Brightness.light),
  dark._(Brightness.dark),
  ;

  final Brightness brightness;

  const AdaptiveThemeState._(this.brightness);
}
