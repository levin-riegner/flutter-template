import 'dart:async';

import 'package:flutter_template/data/article/repository/article_repository.dart';
import 'package:flutter_template/presentation/articles/articles_state.dart';
import 'package:flutter_template/presentation/util/base_bloc.dart';
import 'package:flutter_template/presentation/util/data_state.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:rxdart/rxdart.dart';

class ArticlesBloc extends BaseBloc {

  // Repository
  final _articlesRepository = getIt.get<ArticleRepository>();

  // Observables
  final _state = BehaviorSubject<ArticlesState>.seeded(
      ArticlesState.content(articles: Idle()));
  Stream get state => _state.stream;

  ArticlesBloc() {
    _getArticles();
  }

  void _getArticles() async {
    _state.value = ArticlesState.content(articles: Loading());
    try {
      final articles = await _articlesRepository.getArticles();
      print("got articles");
      _state.value = ArticlesState.content(articles: Success(data: articles));
    } catch (e) {
      print("got articles error: $e");
      // TODO: Error handling
    }
  }

  @override
  void dispose() {
    _state.close();
  }
}