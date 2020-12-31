import 'package:flutter/material.dart';
import 'package:flutter_template/presentation/articles/detail/article_detail_bloc.dart';
import 'package:lr_design_system/views/ds_content_placeholder_views.dart';
import 'package:lr_design_system/views/ds_inapp_webview.dart';
import 'package:provider/provider.dart';

class ArticleDetailPage extends StatefulWidget {
  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ArticleDetailBloc>(context);
    return InAppWebView(
      urlNotifier: ValueNotifier(bloc.url),
      useScaffold: true,
      title: bloc.title,
    );
  }
}
