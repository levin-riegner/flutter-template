import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/app/config/environment.dart';
import 'package:flutter_template/app/navigation/parameters/article_arguments.dart';
import 'package:flutter_template/app/navigation/routes.dart';
import 'package:flutter_template/data/article/repository/article_repository.dart';
import 'package:flutter_template/presentation/articles/articles_bloc.dart';
import 'package:flutter_template/presentation/articles/articles_page.dart';
import 'package:flutter_template/presentation/articles/detail/article_detail_bloc.dart';
import 'package:flutter_template/presentation/articles/detail/article_detail_page.dart';
import 'package:flutter_template/presentation/splash/splash_screen.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:flutter_template/util/integrations/analytics.dart';
import 'package:logging_flutter/flogger.dart';
import 'package:provider/provider.dart';

class Router {
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
    final environment = getIt<Environment>();
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
}
