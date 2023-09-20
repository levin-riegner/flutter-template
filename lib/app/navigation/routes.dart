import 'dart:ui';

import 'package:go_router/go_router.dart';

///
/// Adding new routes:
/// - Parent routes must start with "/".
/// - Child routes may not start or end with "/".

// TODO: Query Params example
sealed class AppRoute {
  final String relativeLocation;
  final AppRoute? parent;
  final Brightness? brightness;

  const AppRoute({
    required this.relativeLocation,
    this.parent,
    this.brightness,
  });

  String get location => parent != null
      ? "${parent?.location}/$relativeLocation"
      : relativeLocation;
}

//#region Articles
class ArticleRoute extends AppRoute {
  static const String routerPath = "/articles";

  const ArticleRoute()
      : super(
          relativeLocation: routerPath,
          brightness: Brightness.light,
        );
}

class ArticleDetailRoute extends AppRoute {
  static const String routerPath = ":id";

  final String id;

  ArticleDetailRoute({
    required this.id,
  }) : super(
          parent: const ArticleRoute(),
          relativeLocation: id,
          brightness: Brightness.light,
        );

  factory ArticleDetailRoute.fromState(GoRouterState state) {
    final id = state.pathParameters["id"]!;
    return ArticleDetailRoute(id: id);
  }
}
//#endregion

//#region Settings
class SettingsRoute extends AppRoute {
  static const String routerPath = "/settings";

  const SettingsRoute()
      : super(
          relativeLocation: routerPath,
          brightness: Brightness.dark,
        );
}
//#endregion

//#region Console
class ConsoleRoute extends AppRoute {
  static const String routerPath = "/console";

  const ConsoleRoute() : super(relativeLocation: routerPath);
}

class ConsoleEnvironmentsRoute extends AppRoute {
  static const String routerPath = "environments";

  const ConsoleEnvironmentsRoute()
      : super(
          parent: const ConsoleRoute(),
          relativeLocation: routerPath,
        );
}

class ConsoleLoginsRoute extends AppRoute {
  static const String routerPath = "logins";

  const ConsoleLoginsRoute()
      : super(
          parent: const ConsoleRoute(),
          relativeLocation: routerPath,
        );
}

class ConsoleQaConfigsRoute extends AppRoute {
  static const String routerPath = "qa-configs";

  const ConsoleQaConfigsRoute()
      : super(
          parent: const ConsoleRoute(),
          relativeLocation: routerPath,
        );
}
//#endregion
