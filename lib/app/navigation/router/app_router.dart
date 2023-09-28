import 'package:flutter/widgets.dart';
import 'package:flutter_template/app/navigation/redirect/route_redirect.dart';
import 'package:flutter_template/app/navigation/router/app_routes.dart';
import 'package:flutter_template/presentation/articles/articles_page.dart';
import 'package:flutter_template/presentation/articles/blank_page.dart';
import 'package:flutter_template/presentation/articles/detail/article_detail_page.dart';
import 'package:flutter_template/presentation/authentication/login/login_page.dart';
import 'package:flutter_template/presentation/bottom_navigation/bottom_navigation_page.dart';
import 'package:flutter_template/presentation/settings/account_details_page.dart';
import 'package:flutter_template/presentation/settings/settings_page.dart';
import 'package:flutter_template/util/console/console_deeplinks.dart';
import 'package:flutter_template/util/console/console_environments.dart';
import 'package:flutter_template/util/console/console_logins.dart';
import 'package:flutter_template/util/console/console_page.dart';
import 'package:flutter_template/util/console/console_qa_config.dart';
import 'package:flutter_template/util/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:logging_flutter/logging_flutter.dart';

abstract class AppRouterBuilder {
  const AppRouterBuilder._();

  static GoRouter buildRouter({
    GlobalKey<NavigatorState>? rootNavigatorKey,
    List<RouteRedirect> redirects = const [],
    String? initialLocation,
  }) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: initialLocation,
      // Logs are already captured by logging_flutter using the "GoRouter" logger name
      debugLogDiagnostics: false,
      onException: (context, state, router) {
        Flogger.w(
            "GoRouterException for location ${state.uri} with error: ${state.error}");
        router.go("/");
      },
      redirect: (context, state) {
        for (final redirect in redirects) {
          final redirectPath = redirect.redirectTo(context, state);
          if (redirectPath != null) {
            return redirectPath;
          }
        }
        return null;
      },
      routes: [
        //#region Console
        GoRoute(
          // Use parent navigator to navigate without bottom bar
          parentNavigatorKey: rootNavigatorKey,
          name: AppRouteData.console.name,
          path: AppRouteData.console.relativePath,
          builder: (context, state) {
            return const ConsolePage();
          },
          routes: [
            GoRoute(
              // Maintain parent navigator to allow for back navigation
              // combined with forward "push" navigation
              parentNavigatorKey: rootNavigatorKey,
              name: AppRouteData.consoleEnvironments.name,
              path: AppRouteData.consoleEnvironments.relativePath,
              builder: (context, state) {
                return const ConsoleEnvironments();
              },
            ),
            GoRoute(
              parentNavigatorKey: rootNavigatorKey,
              name: AppRouteData.consoleLogins.name,
              path: AppRouteData.consoleLogins.relativePath,
              builder: (context, state) {
                return const ConsoleLogins();
              },
            ),
            GoRoute(
              parentNavigatorKey: rootNavigatorKey,
              name: AppRouteData.consoleQaConfigs.name,
              path: AppRouteData.consoleQaConfigs.relativePath,
              builder: (context, state) {
                return const ConsoleQaConfigs();
              },
            ),
            GoRoute(
              parentNavigatorKey: rootNavigatorKey,
              name: AppRouteData.consoleDeeplinks.name,
              path: AppRouteData.consoleDeeplinks.relativePath,
              builder: (context, state) {
                return const ConsoleDeeplinks();
              },
            ),
          ],
        ),
        //#endregion
        //#region Bottom Navigation
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return BottomNavigationPage(
              navigationShell: navigationShell,
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: AppRouteData.articles.name,
                  path: AppRouteData.articles.relativePath,
                  builder: (context, state) {
                    return const ArticlesPage();
                  },
                  routes: [
                    GoRoute(
                      name: AppRouteData.articleDetail.name,
                      path: AppRouteData.articleDetail.relativePath,
                      builder: (context, state) {
                        return ArticleDetailPage(
                          id: ArticleDetailRoute.getIdFromState(state),
                          url: ArticleDetailRoute.getUrlFromState(state),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                    name: AppRouteData.blank.name,
                    path: AppRouteData.blank.relativePath,
                    builder: (context, state) {
                      return const BlankPage();
                    },
                    routes: [
                      GoRoute(
                        parentNavigatorKey: rootNavigatorKey,
                        name: AppRouteData.articleBlankDetail.name,
                        path: AppRouteData.articleBlankDetail.relativePath,
                        builder: (context, state) {
                          return ArticleDetailPage(
                            id: ArticleDetailRoute.getIdFromState(state),
                            url: ArticleDetailRoute.getUrlFromState(state),
                          );
                        },
                      ),
                    ]),
              ],
            ),
          ],
        ),
        //#endregion
        //#region Settings
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          name: AppRouteData.settings.name,
          path: AppRouteData.settings.relativePath,
          onExit: (context) {
            Flogger.i("Exiting settings");
            if (!context.router.canPop()) {
              context.go(AppRouteData.articles.fullPath);
            }
            return true;
          },
          builder: (context, state) {
            return const SettingsPage();
          },
          routes: [
            GoRoute(
              parentNavigatorKey: rootNavigatorKey,
              name: AppRouteData.accountDetails.name,
              path: AppRouteData.accountDetails.relativePath,
              builder: (context, state) {
                final name = AccountDetailsRoute.getUsernameFromState(state);
                return AccountDetailsPage(name: name);
              },
            ),
          ],
        ),
        //#endregion
        //#region Authentication
        // TODO: Auth routes
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: "/login",
          builder: (context, state) {
            return const LoginPage();
          },
        ),
        //#endregion
      ],
    );
  }
}
