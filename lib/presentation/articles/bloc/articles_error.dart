import 'package:freezed_annotation/freezed_annotation.dart';

part 'articles_error.freezed.dart';

@freezed
class ArticlesError with _$ArticlesError {
  const factory ArticlesError.subscriptionExpired() = _SubscriptionExpired;
  const factory ArticlesError.unknown({String? reason}) = _Unknown;
}
