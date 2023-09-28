import 'package:flutter/widgets.dart';

/// Provides a way to keep a reference of the [NavigatorState] globally.
class NavigatorHolder {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: "rootNavigatorKey");

  /// Returns the BuildContext for the root navigator.
  static BuildContext? get context => rootNavigatorKey.currentState?.context;
}
