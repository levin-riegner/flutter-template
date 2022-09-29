import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/app/config/constants.dart';
import 'package:flutter_template/app/l10n/l10n.dart';
import 'package:flutter_template/app/navigation/routes.dart';
import 'package:flutter_template/data/article/model/article.dart';
import 'package:flutter_template/data/article/repository/article_repository.dart';
import 'package:flutter_template/presentation/articles/bloc/articles_bloc.dart';
import 'package:flutter_template/presentation/articles/bloc/articles_event.dart';
import 'package:flutter_template/presentation/articles/bloc/articles_state.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/alert_service.dart';
import 'package:flutter_template/presentation/shared/design_system/utils/dimens.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_app_version.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_content_placeholder_views.dart';
import 'package:flutter_template/presentation/shared/design_system/views/ds_loading_indicator.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:logging_flutter/logging_flutter.dart';
import 'package:provider/provider.dart';

class ArticlesPage extends StatelessWidget implements AutoRouteWrapper {
  const ArticlesPage({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return Provider<ArticlesBloc>(
      create: (context) => ArticlesBloc(
        getIt<ArticleRepository>(),
      )..add(const ArticlesEvent.fetch()),
      dispose: (context, bloc) => bloc.close(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = RefreshIndicator(
      onRefresh: () {
        context
            .read<ArticlesBloc>()
            .add(const ArticlesEvent.fetch(forceRefresh: true));
        return Future.value();
      },
      child: BlocBuilder<ArticlesBloc, ArticlesState>(
        builder: (context, state) {
          return state.when(
            articlesList: (content) {
              return content.when(
                idle: () => Container(),
                loading: () => _Loading(),
                success: (articles) {
                  if (articles.isEmpty) {
                    return const DSEmptyView();
                  }
                  return ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, position) {
                      final Article article = articles[position];
                      return _ArticleView(
                        article,
                        () {
                          Flogger.i(
                              "Navigate to article with id ${article.id}");
                          AutoRouter.of(context).pushNamed(
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
                    onRefresh: () => context
                        .read<ArticlesBloc>()
                        .add(const ArticlesEvent.fetch(forceRefresh: true)),
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
            icon: const Icon(Icons.star),
            onPressed: () async {
              // In-app review
              try {
                final InAppReview inAppReview = InAppReview.instance;
                if (await inAppReview.isAvailable()) {
                  inAppReview.requestReview();
                } else {
                  inAppReview.openStoreListing(
                    appStoreId: Constants.appstoreAppId,
                  );
                }
              } catch (e) {
                Flogger.i("Error requesting app review: $e");
              }
            },
          ),
          const Padding(
            padding: EdgeInsets.all(Dimens.marginMedium),
            child: DSAppVersion(),
          )
        ],
      ),
      body: BlocListener<ArticlesBloc, ArticlesState>(
        listener: (context, state) {
          state.when(articlesList: (state) {
            state.maybeWhen(
                success: (data) {
                  if (data.isEmpty) {
                    AlertService.showAlert(
                      context: context,
                      message: context.l10n.noArticlesFound,
                    );
                  }
                },
                orElse: () {});
          });
        },
        child: body,
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: DSLoadingIndicator(),
    );
  }
}

class _ArticleView extends StatelessWidget {
  final Article _article;
  final VoidCallback _onTap;

  const _ArticleView(this._article, this._onTap);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: _onTap,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.marginMedium),
          child: Column(
            children: [
              if (_article.imageUrl != null)
                Semantics(
                  label: context.l10n.articleThumbnailAlt,
                  child: CachedNetworkImage(imageUrl: _article.imageUrl!),
                ),
              Dimens.boxMedium,
              Text(_article.title!),
            ],
          ),
        ),
      ),
    );
  }
}
