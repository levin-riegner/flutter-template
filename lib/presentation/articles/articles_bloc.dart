import 'dart:async';

import 'package:flutter_template/data/article/repository/article_repository.dart';
import 'package:flutter_template/presentation/articles/articles_error.dart';
import 'package:flutter_template/presentation/articles/articles_state.dart';
import 'package:flutter_template/presentation/util/base_bloc.dart';
import 'package:flutter_template/presentation/util/data_state.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:flutter_template/util/tools/flogger.dart';
import 'package:rxdart/rxdart.dart';

class ArticlesBloc extends BaseBloc {
  static const kQuery = "Bitcoin";

  // Repository
  final _articlesRepository = getIt.get<ArticleRepository>();

  // Observables
  final _state = BehaviorSubject<ArticlesState>.seeded(
      ArticlesState.content(articles: Idle()));

  Stream get state => _state.stream;

  ArticlesBloc() {
    _getArticles();
  }

  // region Public

  Future<void> refresh() async {
    _getArticles(forceRefresh: true);
  }

  // endregion

  // region Private
  Future<void> _getArticles({bool forceRefresh = false}) async {
    _state.value = ArticlesState.content(articles: Loading());
    try {
      final articles = await _articlesRepository.getArticles(kQuery, forceRefresh: forceRefresh);
      _state.value = ArticlesState.content(articles: Success(data: articles));
    } catch (e) {
      Flogger.w("Error getting articles", object: e);
      // TODO: Error handling
      _state.value =
          ArticlesState.content(articles: Failure(reason: Unknown()));
    }
  }

  // endregion

  @override
  void dispose() {
    _state.close();
  }
}
