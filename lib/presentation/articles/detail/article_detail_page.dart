import 'package:flutter/material.dart';
import 'package:color_picker/data/article/repository/article_repository.dart';
import 'package:color_picker/presentation/articles/detail/article_detail_bloc.dart';
import 'package:color_picker/presentation/shared/design_system/utils/inapp_webview.dart';
import 'package:color_picker/util/dependencies.dart';
import 'package:provider/provider.dart';

class ArticleDetailPage extends StatelessWidget {
  final String id;
  final String url;
  final String? title;

  const ArticleDetailPage({
    super.key,
    required this.id,
    required this.url,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Provider<ArticleDetailBloc>(
      create: (context) => ArticleDetailBloc(
        id,
        getIt<ArticleRepository>(),
      ),
      dispose: (context, bloc) => bloc.close(),
      child: ArticleDetailView(
        url: url,
        title: title,
      ),
    );
  }
}

class ArticleDetailView extends StatelessWidget {
  final String url;
  final String? title;

  const ArticleDetailView({
    super.key,
    required this.url,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        // Close Keyboard if open
        FocusScope.of(context).unfocus();
      },
      child: InAppWebView(
        initialUrl: url,
        useScaffold: true,
        title: title,
      ),
    );
  }
}
