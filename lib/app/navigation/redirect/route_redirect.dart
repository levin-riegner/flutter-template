import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

abstract interface class RouteRedirect {
  /// Returns the path to redirect to, or null if no redirect is needed.
  FutureOr<String?> redirectTo(BuildContext context, GoRouterState state);
}
