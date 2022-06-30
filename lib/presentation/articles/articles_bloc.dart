import 'dart:async';

import 'package:flutter_template/data/article/model/article_data_error.dart'
    as data;
import 'package:flutter_template/data/article/repository/article_repository.dart';
import 'package:flutter_template/data/shared/model/error/data_error.dart';
import 'package:flutter_template/presentation/articles/articles_alert.dart';
import 'package:flutter_template/presentation/articles/articles_state.dart';
import 'package:flutter_template/presentation/util/base_bloc.dart';
import 'package:flutter_template/presentation/util/data_state.dart';
import 'package:logging_flutter/flogger.dart';
import 'package:rxdart/rxdart.dart';

class ArticlesBloc extends BaseBloc {
  static const kQuery = "Flutter";

  // Repository
  final ArticleRepository _articlesRepository;

  // Observables
  final _state = BehaviorSubject<ArticlesState>.seeded(
      const ArticlesState.content(articles: Idle()));

  Stream<ArticlesState> get state => _state.stream;

  final _alerts = PublishSubject<ArticlesAlert>();

  Stream<ArticlesAlert> get alerts => _alerts.stream;

  ArticlesBloc(this._articlesRepository) {
    _getArticles();
  }

  // region Public

  Future<void> refresh() async {
    _getArticles(forceRefresh: true);
  }

  // endregion

  // region Private
  Future<void> _getArticles({bool forceRefresh = false}) async {
    _state.add(const ArticlesState.content(articles: Loading()));
    try {
      final articles = await _articlesRepository.getArticles(kQuery,
          forceRefresh: forceRefresh);
      _state.add(ArticlesState.content(articles: Success(data: articles)));
    } on data.ArticleDataError catch (e) {
      _state.add(
        e.when(
          subscriptionExpired: () {
            Flogger.info("Subscription Expired");
            return const ArticlesState.subscriptionExpired();
          },
        ),
      );
    } on DataError catch (e) {
      _state.add(
        e.when(
          notFound: () {
            Flogger.info("Content not found for query $kQuery");
            _alerts.add(const QueryNotFound(kQuery));
            return const ArticlesState.content(articles: Success(data: []));
          },
          apiError: (reason) {
            Flogger.w("Api error getting articles", object: reason);
            return ArticlesState.content(
                articles: Failure(reason: DataError.apiError(reason: reason)));
          },
          unknown: (error) {
            Flogger.w("Unknown error getting articles", object: error);
            return ArticlesState.content(
                articles: Failure(reason: DataError.unknown(error: error)));
          },
        ),
      );
    } catch (e) {
      Flogger.w("Unexpected error getting articles", object: e);
      _state.add(ArticlesState.content(
          articles: Failure(reason: DataError.unknown(error: e))));
    }
  }

  // endregion

  @override
  void dispose() {
    _state.close();
    _alerts.close();
  }
}
