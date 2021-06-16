import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/articles/detail/article_detail_bloc.dart';
import 'package:lr_design_system/views/ds_inapp_webview.dart';
import 'package:provider/provider.dart';

class ArticleDetailPage extends StatefulWidget implements AutoRouteWrapper {

  final String id;
  final String? title;
  final String? url;

  const ArticleDetailPage({
    @PathParam('id') required this.id,
    this.title,
    this.url,
  });

  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return Provider<ArticleDetailBloc>(
      create: (context) => ArticleDetailBloc(title, url),
      dispose: (_, bloc) => bloc.dispose(),
      child: this,
    );
  }
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ArticleDetailBloc>(context);
    return WillPopScope(
      onWillPop: () async {
        // Close Keyboard if open
        FocusScope.of(context).unfocus();
        return true; // Continue with pop
      },
      child: InAppWebView(
        urlNotifier: ValueNotifier(bloc.url!),
        useScaffold: true,
        title: bloc.title,
      ),
    );
  }
}
