import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/app/navigation/parameters/article_detail_arguments.dart';
import 'package:flutter_template/app/navigation/routes.dart';
import 'package:flutter_template/data/article/model/article.dart';
import 'package:flutter_template/presentation/articles/articles_bloc.dart';
import 'package:flutter_template/presentation/articles/articles_state.dart';
import 'package:lr_design_system/theme/theme.dart';
import 'package:lr_design_system/theme/theme_spacing.dart';
import 'package:lr_design_system/views/ds_content_placeholder_views.dart';
import 'package:lr_design_system/views/ds_loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/strings.dart';

class ArticlesPage extends StatefulWidget {
  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<ArticlesBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.of(context).articlesTitle),
      ),
      body: RefreshIndicator(
        onRefresh: () => bloc.refresh(),
        child: StreamBuilder<ArticlesState>(
          stream: bloc.state,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            final state = snapshot.data;
            return state.when(confirmRegistration: () {
              return Text("Please confirm registration");
            }, content: (content) {
              return content.when(
                  idle: () => _Loading(),
                  loading: () => _Loading(),
                  success: (articles) {
                    if (articles.isEmpty) return DSEmptyView(useScaffold: false);
                    return ListView.builder(
                        itemCount: articles.length,
                        itemBuilder: (context, position) {
                          final article = articles[position];
                          return _Article(article, () {
                            Navigator.of(context).pushNamed(
                              Routes.articleDetail,
                              arguments: ArticleDetailArguments(
                                title: article.title,
                                url: article.url,
                              ),
                            );
                          });
                        });
                  },
                  failure: (error) {
                    return DSErrorView(useScaffold: false);
                  });
            });
          },
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DSLoadingIndicator(),
    );
  }
}

class _Article extends StatelessWidget {
  final Article _article;
  final VoidCallback _onTap;

  const _Article(this._article, this._onTap);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(ThemeProvider.theme.spacing.m),
          child: Column(
            children: [
              if (_article.imageUrl != null)
                CachedNetworkImage(imageUrl: _article.imageUrl),
              ThemeSpacing.Medium,
              Text(_article.title),
            ],
          ),
        ),
        onTap: _onTap,
      ),
    );
  }
}
