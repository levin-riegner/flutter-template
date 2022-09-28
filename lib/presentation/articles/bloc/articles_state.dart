import 'package:flutter_template/data/article/model/article.dart';
import 'package:flutter_template/presentation/articles/bloc/articles_error.dart';
import 'package:flutter_template/presentation/shared/util/data_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'articles_state.freezed.dart';

@freezed
class ArticlesState with _$ArticlesState {
  const factory ArticlesState.articlesList({
    required DataState<List<Article>, ArticlesError> data,
  }) = _ArticlesList;
}
