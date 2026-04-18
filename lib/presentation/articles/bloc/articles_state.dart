import 'package:color_picker/data/article/model/article.dart';
import 'package:color_picker/presentation/articles/bloc/articles_error.dart';
import 'package:color_picker/presentation/shared/util/data_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'articles_state.freezed.dart';

@freezed
sealed class ArticlesState with _$ArticlesState {
  const factory ArticlesState.articlesList({
    required DataState<List<Article>, ArticlesError> data,
  }) = _ArticlesList;
}
