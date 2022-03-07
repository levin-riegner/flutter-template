import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_data_error.freezed.dart';

@freezed
class ArticleDataError with _$ArticleDataError {
  const factory ArticleDataError.subscriptionExpired() = SubscriptionExpired;
}
