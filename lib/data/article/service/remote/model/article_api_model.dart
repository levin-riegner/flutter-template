import 'package:flutter_template/data/article/model/article.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'article_api_model.freezed.dart';
part 'article_api_model.g.dart';

@freezed
abstract class ArticleApiModel implements _$ArticleApiModel {
  const ArticleApiModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ArticleApiModel({
    String id,
    String title,
    String url,
    @JsonKey(name: "read_time") int readTimeInSeconds,
    int publishedAt,
  }) = _ArticleApiModel;

  factory ArticleApiModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleApiModelFromJson(json);

  Article toArticle() {
    return Article(
      id: id,
      title: title,
      url: url,
      readTimeInSeconds: readTimeInSeconds,
      publishedAt: DateTime.fromMillisecondsSinceEpoch(publishedAt),
    );
  }
}
