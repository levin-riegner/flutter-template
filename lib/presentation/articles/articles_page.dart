import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:flutter_template/app/config/constants.dart';
import 'package:flutter_template/app/navigation/router/app_router.gr.dart';
import 'package:flutter_template/app/navigation/routes.dart';
import 'package:flutter_template/data/article/model/article.dart';
import 'package:flutter_template/presentation/articles/articles_bloc.dart';
import 'package:flutter_template/presentation/articles/articles_state.dart';
import 'package:flutter_template/presentation/util/base_stateful_widget.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:logging_flutter/flogger.dart';
import 'package:lr_design_system/utils/alert_service.dart';
import 'package:lr_design_system/utils/dimens.dart';
import 'package:lr_design_system/views/ds_app_version.dart';
import 'package:lr_design_system/views/ds_content_placeholder_views.dart';
import 'package:lr_design_system/views/ds_loading_indicator.dart';

class ArticlesPage extends StatefulWidget {
  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends BaseState<ArticlesPage, ArticlesBloc> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen to Alerts
    bloc.alerts.listen((alert) {
      alert.when(
        queryNotFound: (query) {
          return AlertService.instance()!.showAlert(
            context: context,
            message: context.l10n.noArticlesFound(query),
          );
        },
      );
    }).disposedBy(disposeBag);
  }

  @override
  Widget build(BuildContext context) {
    final body = RefreshIndicator(
      onRefresh: () => bloc.refresh(),
      child: StreamBuilder<ArticlesState>(
        stream: bloc.state,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          final state = snapshot.data!;
          return state.when(
            subscriptionExpired: () {
              return Text("Please renew your subscription");
            },
            content: (content) {
              return content.when(
                idle: () => Container(),
                loading: () => _Loading(),
                success: (articles) {
                  if (articles.isEmpty) return DSEmptyView(useScaffold: false);
                  return ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, position) {
                      final Article article = articles[position];
                      return _Article(
                        article,
                        () {
                          AutoRouter.of(context).navigateNamed(
                            Routes.articleDetails(article.id ?? ""),
                          );
                        },
                      );
                    },
                  );
                },
                failure: (error) {
                  return DSErrorView(
                    useScaffold: false,
                    onRefresh: () => bloc.refresh(),
                  );
                },
              );
            },
          );
        },
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.articlesTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () async {
              // In-app review
              try {
                final InAppReview inAppReview = InAppReview.instance;
                if (await inAppReview.isAvailable()) {
                  inAppReview.requestReview();
                } else {
                  inAppReview.openStoreListing(
                    appStoreId: Constants.APPSTORE_APP_ID,
                  );
                }
              } catch (e) {
                Flogger.i("Error requesting app review", object: e);
              }
            },
          ),
          Padding(
            padding: EdgeInsets.all(Dimens.of(context).marginMedium),
            child: DSAppVersion(),
          )
        ],
      ),
      body: body,
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
          padding: EdgeInsets.all(Dimens.of(context).marginMedium),
          child: Column(
            children: [
              if (_article.imageUrl != null)
                Semantics(
                  child: CachedNetworkImage(imageUrl: _article.imageUrl!),
                  label: context.l10n.articleThumbnailAlt,
                ),
              Dimens.of(context).boxMedium,
              Text(_article.title!),
            ],
          ),
        ),
        onTap: _onTap,
      ),
    );
  }
}
