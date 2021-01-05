import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'articles_error.freezed.dart';

@freezed
abstract class ArticlesError with _$ArticlesError {

  const factory ArticlesError.unknown() = Unknown;
}
