import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/data/article/repository/article_repository.dart';
import 'package:flutter_template/presentation/articles/detail/article_detail_bloc.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_inapp_webview.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:provider/provider.dart';

class ArticleDetailPage extends StatelessWidget implements AutoRouteWrapper {
  final String id;
  final String? title;
  final String? url;

  const ArticleDetailPage({
    Key? key,
    @PathParam("id") required this.id,
    this.title,
    this.url,
  }) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return Provider<ArticleDetailBloc>(
      create: (context) => ArticleDetailBloc(
        id,
        getIt<ArticleRepository>(),
      ),
      dispose: (context, bloc) => bloc.close(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Close Keyboard if open
        FocusScope.of(context).unfocus();
        return true; // Continue with pop
      },
      child: InAppWebView(
        urlNotifier: ValueNotifier(url ?? "https://levinriegner.com"),
        useScaffold: true,
        title: title,
      ),
    );
  }
}
