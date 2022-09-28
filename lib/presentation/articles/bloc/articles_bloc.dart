import 'dart:async';

import 'package:flutter_template/data/article/repository/article_repository.dart';
import 'package:flutter_template/data/shared/model/error/data_error.dart';
import 'package:flutter_template/presentation/articles/bloc/articles_error.dart'
    as data;
import 'package:flutter_template/presentation/articles/bloc/articles_event.dart';
import 'package:flutter_template/presentation/articles/bloc/articles_state.dart';
import 'package:flutter_template/presentation/shared/util/data_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging_flutter/logging_flutter.dart';

class ArticlesBloc extends HydratedBloc<ArticlesEvent, ArticlesState> {
  static const kQuery = "Flutter";

  // Repository
  final ArticleRepository _articlesRepository;

  ArticlesBloc(this._articlesRepository)
      :
        // Initial state
        super(
          const ArticlesState(
            currentState: Idle(),
          ),
        ) {
    // Capture events to emit new state
    on<ArticlesEvent>((event, emit) {
      event.when(
        fetch: () => _getArticles(emit),
        refresh: () => refresh(emit),
      );
    });
  }

  // region Public

  @override
  ArticlesState? fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic>? toJson(ArticlesState state) {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  Future<void> refresh(Emitter<ArticlesState> emit) async {
    _getArticles(emit, forceRefresh: true);
  }

  // endregion

  // region Private
  Future<void> _getArticles(
    Emitter<ArticlesState> emit, {
    bool forceRefresh = false,
  }) async {
    emit(
      const ArticlesState(
        currentState: Loading(),
      ),
    );

    try {
      final articles = await _articlesRepository.getArticles(kQuery,
          forceRefresh: forceRefresh);
      emit(
        ArticlesState(
          currentState: Success(data: articles),
        ),
      );
    } on data.ArticleDataError catch (e) {
      emit(
        e.when(
          subscriptionExpired: () {
            Flogger.i("Subscription Expired");
            return const ArticlesState(
              currentState: Failure(
                reason: DataError.unknown(),
              ),
            );
          },
        ),
      );
    } on DataError catch (e) {
      emit(
        e.when(
          notFound: () {
            Flogger.i("Content not found for query $kQuery");
            return const ArticlesState(
              currentState: Success(
                data: [],
              ),
            );
          },
          apiError: (reason) {
            Flogger.w("Api error getting articles: $reason");
            return ArticlesState(
              currentState: Failure(
                reason: DataError.apiError(reason: reason),
              ),
            );
          },
          unknown: (error) {
            Flogger.w("Unknown error getting articles: $error");
            return ArticlesState(
              currentState: Failure(
                reason: DataError.unknown(error: error),
              ),
            );
          },
        ),
      );
    } catch (e) {
      Flogger.w("Unexpected error getting articles: $e");
      emit(
        ArticlesState(
          currentState: Failure(
            reason: DataError.unknown(error: e),
          ),
        ),
      );
    }
  }

  // endregion
}
