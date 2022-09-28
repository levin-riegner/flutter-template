import 'dart:async';

import 'package:flutter_template/data/article/repository/article_repository.dart';
import 'package:flutter_template/data/shared/model/error/data_error.dart';
import 'package:flutter_template/presentation/articles/bloc/articles_error.dart';
import 'package:flutter_template/presentation/articles/bloc/articles_event.dart';
import 'package:flutter_template/presentation/articles/bloc/articles_state.dart';
import 'package:flutter_template/presentation/shared/util/data_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging_flutter/logging_flutter.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  static const kQuery = "Flutter";

  final ArticleRepository _articlesRepository;

  ArticlesBloc(this._articlesRepository)
      : super(const ArticlesState.articlesList(data: DataState.idle())) {
    on<ArticlesEvent>((event, emit) async {
      await event.when(
        fetch: (forceRefresh) => _getArticles(emit, forceRefresh: forceRefresh),
      );
    });
  }

  Future<void> _getArticles(
    Emitter<ArticlesState> emit, {
    bool forceRefresh = false,
  }) async {
    Flogger.i("Get articles for query $kQuery and forceRefresh $forceRefresh");
    emit(const ArticlesState.articlesList(data: DataState.loading()));

    try {
      final articles = await _articlesRepository.getArticles(kQuery,
          forceRefresh: forceRefresh);
      emit(ArticlesState.articlesList(data: DataState.success(data: articles)));
    } on DataError catch (e) {
      emit(
        e.when(
          notFound: () {
            Flogger.i("Content not found for query $kQuery");
            return const ArticlesState.articlesList(
              data: DataState.success(data: []),
            );
          },
          apiError: (reason) {
            Flogger.w("Api error getting articles: $reason");
            return ArticlesState.articlesList(
              data: DataState.failure(
                  reason: reason?.contains("expired") == true
                      ? const ArticlesError.subscriptionExpired()
                      : ArticlesError.unknown(reason: reason)),
            );
          },
          unknown: (error) {
            Flogger.w("Unknown error getting articles: $error");
            return ArticlesState.articlesList(
              data: DataState.failure(
                reason: ArticlesError.unknown(reason: error.toString()),
              ),
            );
          },
        ),
      );
    } catch (e) {
      Flogger.w("Unexpected error getting articles: $e");
      emit(
        ArticlesState.articlesList(
          data: DataState.failure(
            reason: ArticlesError.unknown(reason: e.toString()),
          ),
        ),
      );
    }
  }
}
