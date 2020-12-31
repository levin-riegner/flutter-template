import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'articles_error.freezed.dart';

@freezed
abstract class ArticlesError<T, Y> with _$ArticlesError {
  const factory ArticlesError.blacklisted() = Blacklisted;

  const factory ArticlesError.subscriptionExpired() = SubscriptionExpired;

  const factory ArticlesError.unknown() = Unknown;
}
