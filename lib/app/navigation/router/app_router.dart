import 'package:auto_route/auto_route.dart';
import 'package:flutter_template/app/navigation/routes.dart';
import 'package:flutter_template/app/navigation/wrappers/article_wrapper_page.dart';
import 'package:flutter_template/presentation/articles/articles_page.dart';
import 'package:flutter_template/presentation/articles/detail/article_detail_page.dart';
import 'package:flutter_template/presentation/bottom_navigation/bottom_navigation_page.dart';
import 'package:flutter_template/presentation/settings/detail/settings_detail_page.dart';
import 'package:flutter_template/presentation/settings/settings_page.dart';
import 'package:flutter_template/util/console/console_environments.dart';
import 'package:flutter_template/util/console/console_logins.dart';
import 'package:flutter_template/util/console/console_qa_config.dart';
import 'package:flutter_template/util/console/console_screen.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: "Page,Route",
  routes: <AutoRoute>[
    AutoRoute(
      path: Routes.home,
      page: BottomNavigationPage,
      children: [
        AutoRoute(
          path: Routes.articles,
          name: "ArticlesRouter",
          page: ArticleWrapperPage,
          children: [
            AutoRoute(path: "", page: ArticlesPage),
            AutoRoute(path: ":id", page: ArticleDetailPage),
            RedirectRoute(path: "*", redirectTo: ""),
          ],
        ),
        AutoRoute(
          path: Routes.settings,
          name: "SettingsRouter",
          page: EmptyRouterPage,
          children: [
            AutoRoute(path: "", page: SettingsPage),
            AutoRoute(path: Routes.settingsDetails, page: SettingsDetailPage),
          ],
        ),
      ],
    ),
    AutoRoute(
      path: Routes.console,
      name: "ConsoleRouter",
      page: EmptyRouterPage,
      children: [
        AutoRoute(
          path: "",
          page: ConsoleScreen,
        ),
        AutoRoute(
          path: Routes.environments,
          page: ConsoleEnvironments,
        ),
        AutoRoute(
          path: Routes.logins,
          page: ConsoleLogins,
        ),
        AutoRoute(
          path: Routes.qaConfigs,
          page: ConsoleQaConfigs,
        ),
        RedirectRoute(path: "*", redirectTo: "")
      ],
    ),
  ],
)
class $AppRouter {}
