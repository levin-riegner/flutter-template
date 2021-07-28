import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lr_design_system/views/ds_inapp_webview.dart';

class ArticleDetailPage extends StatefulWidget {
  final String id;
  final String? title;
  final String? url;

  const ArticleDetailPage({
    @PathParam("id") required this.id,
    this.title,
    this.url,
  });

  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Close Keyboard if open
        FocusScope.of(context).unfocus();
        return true; // Continue with pop
      },
      child: InAppWebView(
        urlNotifier: ValueNotifier(widget.url ?? "https://levinriegner.com"),
        useScaffold: true,
        title: widget.title,
      ),
    );
  }
}
