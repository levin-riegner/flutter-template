import 'dart:ui';

import 'package:flutter_template/util/extensions/go_router_extension.dart';
import 'package:go_router/go_router.dart';

/// This enum contains all routes of the app and
/// matches 1-to-1 with all routes in the GoRouter.
enum AppRouteData {
  //#region Console
  console._(
    name: "ConsolePage",
    parentPath: null,
    relativePath: ConsoleRoute.path,
    brightness: Brightness.dark,
  ),
  consoleEnvironments._(
    name: "ConsoleEnvironmentsPage",
    parentPath: ConsoleRoute.path,
    relativePath: ConsoleEnvironmentsRoute.path,
    brightness: Brightness.dark,
  ),
  consoleLogins._(
    name: "ConsoleLoginsPage",
    parentPath: ConsoleRoute.path,
    relativePath: ConsoleLoginsRoute.path,
    brightness: Brightness.dark,
  ),
  consoleQaConfigs._(
    name: "ConsoleQaConfigsPage",
    parentPath: ConsoleRoute.path,
    relativePath: ConsoleQaConfigsRoute.path,
    brightness: Brightness.dark,
  ),
  consoleDeeplinks._(
    name: "ConsoleDeeplinksPage",
    parentPath: ConsoleRoute.path,
    relativePath: ConsoleDeeplinksRoute.path,
    brightness: Brightness.dark,
  ),
  //#endregion
  //#region Example
  articles._(
    name: "ArticlesPage",
    parentPath: null,
    relativePath: ArticlesRoute.path,
    brightness: Brightness.light,
  ),
  articleDetail._(
    name: "ArticleDetailPage",
    parentPath: ArticlesRoute.path,
    relativePath: ArticleDetailRoute.path,
    brightness: Brightness.light,
  ),
  blank._(
    name: "BlankPage",
    parentPath: null,
    relativePath: "/blank",
    brightness: Brightness.dark,
  ),
  articleBlankDetail._(
    name: "ArticleBlankDetailPage",
    parentPath: "/blank",
    relativePath: ArticleDetailRoute.path,
    brightness: Brightness.light,
  ),
  settings._(
    name: "SettingsPage",
    parentPath: null,
    relativePath: SettingsRoute.path,
    brightness: Brightness.dark,
  ),
  accountDetails._(
    name: "AccountDetailsPage",
    parentPath: SettingsRoute.path,
    relativePath: AccountDetailsRoute.path,
    brightness: Brightness.dark,
  ),
  //#endregion
  ;

  final String name;
  final String? parentPath;
  final String relativePath;
  final Brightness brightness;

  const AppRouteData._({
    required this.name,
    required this.parentPath,
    required this.relativePath,
    required this.brightness,
  });

  factory AppRouteData.fromFullPath(String path) {
    return values.firstWhere((e) => e.fullPath == path);
  }

  factory AppRouteData.fromParentPath(String parentPath, String relativePath) {
    return values.firstWhere(
      (e) =>
          e.parentPath == parentPath &&
          e.relativePath.replaceAll("/", "") ==
              relativePath.replaceAll("/", ""),
    );
  }

  String get fullPath {
    final relativePath = this.relativePath.startsWith("/")
        ? this.relativePath
        : "/${this.relativePath}";
    if (parentPath != null) {
      return "$parentPath$relativePath";
    }
    return relativePath;
  }
}

/// This class holds all information needed to navigate to a route.
/// Use the constructor of its subclasses to create a new route
/// with all the required parameters, and then
/// use the [location] getter to navigate to the route.
sealed class AppRoute {
  final AppRouteData data;
  final String relativeLocation;
  final String? parentLocation;
  final Map<String, dynamic>? queryParameters;

  AppRoute({
    required this.data,
    String? relativeLocation,
    String? parentLocation,
    this.queryParameters,
  })  : relativeLocation = relativeLocation ?? data.relativePath,
        parentLocation = parentLocation ?? data.parentPath;

  // Use this method to navigate to a route
  String get location {
    final relativeLocation = this.relativeLocation.startsWith("/")
        ? this.relativeLocation
        : "/${this.relativeLocation}";
    final url = parentLocation != null
        ? "$parentLocation$relativeLocation"
        : relativeLocation;
    if (queryParameters != null) {
      return Uri(path: url, queryParameters: queryParameters).toString();
    }
    return url;
  }
}

//#region Console
class ConsoleRoute extends AppRoute {
  static const String path = "/console";
  ConsoleRoute() : super(data: AppRouteData.console);
}

class ConsoleEnvironmentsRoute extends AppRoute {
  static const String path = "environments";
  ConsoleEnvironmentsRoute() : super(data: AppRouteData.consoleEnvironments);
}

class ConsoleLoginsRoute extends AppRoute {
  static const String path = "logins";
  ConsoleLoginsRoute() : super(data: AppRouteData.consoleLogins);
}

class ConsoleQaConfigsRoute extends AppRoute {
  static const String path = "qa-configs";
  ConsoleQaConfigsRoute() : super(data: AppRouteData.consoleQaConfigs);
}

class ConsoleDeeplinksRoute extends AppRoute {
  static const String path = "deeplinks";
  ConsoleDeeplinksRoute() : super(data: AppRouteData.consoleDeeplinks);
}

//#endregion
//#region Examples
class ArticlesRoute extends AppRoute {
  static const String path = "/articles";
  ArticlesRoute() : super(data: AppRouteData.articles);
}

// This route requires an id as path parameter
// and can be opened from multiple locations
class ArticleDetailRoute extends AppRoute {
  // Path Parameters
  static const String articleIdKey = "aid";
  static const String path = ":$articleIdKey";
  // Query Parameters
  static const String articleUrlKey = "url";

  ArticleDetailRoute._({
    required String url,
    required super.data,
    required super.parentLocation,
    required super.relativeLocation,
  }) : super(
          queryParameters: {articleUrlKey: url},
        );

  static String getIdFromState(GoRouterState state) {
    return state.pathParameters[articleIdKey]!;
  }

  static String getUrlFromState(GoRouterState state) {
    return state.uri.queryParameters[articleUrlKey]!;
  }

  factory ArticleDetailRoute(
    GoRouter router, {
    required String id,
    required String url,
  }) {
    final parentPath = router.fullPath();
    final parentLocation = router.location().path;
    final data = AppRouteData.fromParentPath(parentPath, path);
    final relativeLocation =
        data.relativePath.replaceAll(":${ArticleDetailRoute.articleIdKey}", id);
    return ArticleDetailRoute._(
      url: url,
      data: data,
      parentLocation: parentLocation,
      relativeLocation: relativeLocation,
    );
  }
}

class SettingsRoute extends AppRoute {
  static const String path = "/settings";
  SettingsRoute() : super(data: AppRouteData.settings);
}

// This route contains query parameters
class AccountDetailsRoute extends AppRoute {
  static const String path = "account-details";
  // Query Parameters (optional)
  static const String usernameKey = "name";

  AccountDetailsRoute({
    String? username,
  }) : super(
          data: AppRouteData.accountDetails,
          queryParameters: username != null ? {usernameKey: username} : null,
        );

  static String getUsernameFromState(GoRouterState state) {
    return state.uri.queryParameters[usernameKey]!;
  }
}
//#endregion
