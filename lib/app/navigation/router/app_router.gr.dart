// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;
import 'package:flutter_template/app/navigation/wrappers/article_wrapper_page.dart'
    as _i3;
import 'package:flutter_template/presentation/articles/articles_page.dart'
    as _i4;
import 'package:flutter_template/presentation/articles/detail/article_detail_page.dart'
    as _i5;
import 'package:flutter_template/util/console/console_environments.dart' as _i7;
import 'package:flutter_template/util/console/console_logins.dart' as _i8;
import 'package:flutter_template/util/console/console_qa_config.dart' as _i9;
import 'package:flutter_template/util/console/console_screen.dart' as _i6;

class AppRouter extends _i1.RootStackRouter {
  AppRouter([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    ArticlesRouter.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<ArticlesRouterArgs>(
              orElse: () => const ArticlesRouterArgs());
          return _i3.ArticleWrapperPage(key: args.key);
        }),
    ConsoleRouter.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i1.EmptyRouterPage();
        }),
    ArticlesRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i4.ArticlesPage();
        }),
    ArticleDetailRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final pathParams = data.pathParams;
          final args = data.argsAs<ArticleDetailRouteArgs>(
              orElse: () =>
                  ArticleDetailRouteArgs(id: pathParams.getString('id')));
          return _i5.ArticleDetailPage(
              id: args.id, title: args.title, url: args.url);
        }),
    ConsoleScreen.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i6.ConsoleScreen();
        }),
    ConsoleEnvironments.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i7.ConsoleEnvironments();
        }),
    ConsoleLogins.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i8.ConsoleLogins();
        }),
    ConsoleQaConfigs.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i9.ConsoleQaConfigs();
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig('/#redirect',
            path: '/', redirectTo: '/articles', fullMatch: true),
        _i1.RouteConfig(ArticlesRouter.name, path: '/articles', children: [
          _i1.RouteConfig(ArticlesRoute.name, path: ''),
          _i1.RouteConfig(ArticleDetailRoute.name, path: ':id'),
          _i1.RouteConfig('*#redirect',
              path: '*', redirectTo: '', fullMatch: true)
        ]),
        _i1.RouteConfig(ConsoleRouter.name,
            path: '/empty-router-page',
            children: [
              _i1.RouteConfig(ConsoleScreen.name, path: ''),
              _i1.RouteConfig(ConsoleEnvironments.name,
                  path: 'console-environments'),
              _i1.RouteConfig(ConsoleLogins.name, path: 'console-logins'),
              _i1.RouteConfig(ConsoleQaConfigs.name, path: 'console-qa-configs')
            ])
      ];
}

class ArticlesRouter extends _i1.PageRouteInfo<ArticlesRouterArgs> {
  ArticlesRouter({_i2.Key? key, List<_i1.PageRouteInfo>? children})
      : super(name,
            path: '/articles',
            args: ArticlesRouterArgs(key: key),
            initialChildren: children);

  static const String name = 'ArticlesRouter';
}

class ArticlesRouterArgs {
  const ArticlesRouterArgs({this.key});

  final _i2.Key? key;
}

class ConsoleRouter extends _i1.PageRouteInfo {
  const ConsoleRouter({List<_i1.PageRouteInfo>? children})
      : super(name, path: '/empty-router-page', initialChildren: children);

  static const String name = 'ConsoleRouter';
}

class ArticlesRoute extends _i1.PageRouteInfo {
  const ArticlesRoute() : super(name, path: '');

  static const String name = 'ArticlesRoute';
}

class ArticleDetailRoute extends _i1.PageRouteInfo<ArticleDetailRouteArgs> {
  ArticleDetailRoute({required String id, String? title, String? url})
      : super(name,
            path: ':id',
            args: ArticleDetailRouteArgs(id: id, title: title, url: url),
            rawPathParams: {'id': id});

  static const String name = 'ArticleDetailRoute';
}

class ArticleDetailRouteArgs {
  const ArticleDetailRouteArgs({required this.id, this.title, this.url});

  final String id;

  final String? title;

  final String? url;
}

class ConsoleScreen extends _i1.PageRouteInfo {
  const ConsoleScreen() : super(name, path: '');

  static const String name = 'ConsoleScreen';
}

class ConsoleEnvironments extends _i1.PageRouteInfo {
  const ConsoleEnvironments() : super(name, path: 'console-environments');

  static const String name = 'ConsoleEnvironments';
}

class ConsoleLogins extends _i1.PageRouteInfo {
  const ConsoleLogins() : super(name, path: 'console-logins');

  static const String name = 'ConsoleLogins';
}

class ConsoleQaConfigs extends _i1.PageRouteInfo {
  const ConsoleQaConfigs() : super(name, path: 'console-qa-configs');

  static const String name = 'ConsoleQaConfigs';
}
