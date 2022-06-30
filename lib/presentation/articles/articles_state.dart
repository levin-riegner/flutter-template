import 'package:flutter_template/data/article/model/article.dart';
import 'package:flutter_template/data/shared/model/error/data_error.dart';
import 'package:flutter_template/presentation/util/data_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'articles_state.freezed.dart';

@freezed
class ArticlesState with _$ArticlesState {

  const factory ArticlesState.subscriptionExpired() = SubscriptionExpired;

  const factory ArticlesState.content({
    required DataState<List<Article>, DataError> articles,
  }) = Content;

}
