import 'package:flutter/widgets.dart';
import 'package:flutter_template/app/navigation/routes.dart';
import 'package:flutter_template/presentation/articles/articles_page.dart';
import 'package:flutter_template/presentation/articles/blank_page.dart';
import 'package:flutter_template/presentation/articles/detail/article_detail_page.dart';
import 'package:flutter_template/presentation/authentication/login/login_page.dart';
import 'package:flutter_template/presentation/home/home_page.dart';
import 'package:flutter_template/presentation/settings/settings_page.dart';
import 'package:flutter_template/util/console/console_environments.dart';
import 'package:flutter_template/util/console/console_logins.dart';
import 'package:flutter_template/util/console/console_qa_config.dart';
import 'package:flutter_template/util/console/console_screen.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouterBuilder {
  const AppRouterBuilder._();

  static GoRouter buildRouter({
    GlobalKey<NavigatorState>? navigatorKey,
    String? initialLocation,
    bool debugLog = false,
  }) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: initialLocation,
      debugLogDiagnostics: debugLog,
      routes: [
        // Home
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return HomePage(
              navigationShell: navigationShell,
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: ArticleRoute.routerPath,
                  builder: (context, state) {
                    return const ArticlesPage();
                  },
                  routes: [
                    GoRoute(
                      path: ArticleDetailRoute.routerPath,
                      builder: (context, state) {
                        final route = ArticleDetailRoute.fromState(state);
                        return ArticleDetailPage(
                          id: route.id,
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
                  path: "/blank",
                  builder: (context, state) {
                    return const BlankPage();
                  },
                ),
              ],
            ),
          ],
        ),
        // Settings
        // TODO: Deeplink shouldn't close the app
        GoRoute(
          // Use parent navigator to navigate without bottom bar
          parentNavigatorKey: navigatorKey,
          path: SettingsRoute.routerPath,
          builder: (context, state) {
            return const SettingsPage();
          },
        ),
        // Authentication
        GoRoute(
          path: "/login",
          builder: (context, state) {
            return const LoginPage();
          },
        ),
        //#region Console
        GoRoute(
          path: ConsoleRoute.routerPath,
          builder: (context, state) {
            return const ConsoleScreen();
          },
          routes: [
            GoRoute(
              path: ConsoleEnvironmentsRoute.routerPath,
              builder: (context, state) {
                return const ConsoleEnvironments();
              },
            ),
            GoRoute(
              path: ConsoleLoginsRoute.routerPath,
              builder: (context, state) {
                return const ConsoleLogins();
              },
            ),
            GoRoute(
              path: ConsoleQaConfigsRoute.routerPath,
              builder: (context, state) {
                return const ConsoleQaConfigs();
              },
            ),
          ],
        ),
        //#endregion
      ],
    );
  }
}
