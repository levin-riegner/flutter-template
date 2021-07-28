import 'package:auto_route/auto_route.dart';
import 'package:flutter_template/app/navigation/routes.dart';
import 'package:flutter_template/app/navigation/wrappers/article_wrapper_page.dart';
import 'package:flutter_template/presentation/articles/articles_page.dart';
import 'package:flutter_template/presentation/articles/detail/article_detail_page.dart';
import 'package:flutter_template/util/console/console_environments.dart';
import 'package:flutter_template/util/console/console_logins.dart';
import 'package:flutter_template/util/console/console_qa_config.dart';
import 'package:flutter_template/util/console/console_screen.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: "Page,Route",
  routes: <AutoRoute>[
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

/* class Router {


  Route generate(RouteSettings settings) {
    Flogger.info("Navigating to ${settings.name}");

    switch (settings.name) {
      case Routes.articles:
        Analytics.setCurrentScreenName(AnalyticsScreen.articles);
        return _route(
          settings,
          Provider<ArticlesBloc>(
            create: (context) => ArticlesBloc(getIt.get<ArticleRepository>()),
            dispose: (_, bloc) => bloc.dispose(),
            child: ArticlesPage(),
          ),
        );
      case Routes.articleDetail:
        Analytics.setCurrentScreenName(AnalyticsScreen.articleDetail);
        final params = settings.arguments as ArticleDetailArguments;
        return _route(
          settings,
          Provider<ArticleDetailBloc>(
            create: (context) => ArticleDetailBloc(params.title, params.url),
            dispose: (_, bloc) => bloc.dispose(),
            child: ArticleDetailPage(),
          ),
        );
      default:
        return _route(settings, SplashScreen(Routes.articles));
    }
  }

  Route _route(RouteSettings settings, Widget widget,
      {bool presentModally = false}) {
    final Environment environment = getIt<Environment>();
    widget = environment.isInternal
        ? Banner(
            message: environment.name,
            location: BannerLocation.bottomEnd,
            child: widget,
          )
        : widget;
    return Platform.isIOS
        ? CupertinoPageRoute(
            settings: settings,
            builder: (_) => widget,
            fullscreenDialog: presentModally,
          )
        : MaterialPageRoute(
            settings: settings,
            builder: (_) => widget,
            fullscreenDialog: presentModally,
          );
  }
} */
