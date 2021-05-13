import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_data_error.freezed.dart';

@freezed
class ArticleDataError with _$ArticleDataError {
  const factory ArticleDataError.subscriptionExpired() = SubscriptionExpired;

  const factory ArticleDataError.notFound() = NotFound;

  const factory ArticleDataError.unknown(Object? error) = Unknown;
}
