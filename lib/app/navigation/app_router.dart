// @CupertinoAutoRouter
// @AdaptiveAutoRouter
// @CustomAutoRouter
import 'package:auto_route/auto_route.dart';
import 'package:flutter_template/presentation/articles/articles_page.dart';
import 'package:flutter_template/presentation/articles/detail/article_detail_page.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      name: "ArticlesRouter",
      path: "/articles",
      initial: true,
      page: EmptyRouterPage,
      children: [
        AutoRoute(path: "/", page: ArticlesPage),
        AutoRoute(path: ":id", page: ArticleDetailPage),
        RedirectRoute(path: '*', redirectTo: '/'),
      ],
    ),
  ],
)
class $AppRouter {}
