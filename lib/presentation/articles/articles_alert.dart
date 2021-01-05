import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'articles_alert.freezed.dart';

@freezed
abstract class ArticlesAlert with _$ArticlesAlert {

  const factory ArticlesAlert.queryNotFound(String query) = QueryNotFound;
}
