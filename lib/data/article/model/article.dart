import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'article.freezed.dart';

@freezed
abstract class Article implements _$Article {
  const Article._();

  const factory Article({
    String id,
    String title,
    String description,
    String imageUrl,
    String url,
    DateTime publishedAt,
  }) = _Article;
}
