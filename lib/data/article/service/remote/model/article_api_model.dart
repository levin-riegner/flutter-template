import 'package:flutter_template/data/article/model/article.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'article_api_model.freezed.dart';

part 'article_api_model.g.dart';

@freezed
abstract class ArticleApiModel implements _$ArticleApiModel {
  const ArticleApiModel._();

  // @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ArticleApiModel({
    String id,
    String title,
    String description,
    @JsonKey(name: "urlToImage") String imageUrl,
    String url,
    String publishedAt,
  }) = _ArticleApiModel;

  factory ArticleApiModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleApiModelFromJson(json);

  Article toArticle() {
    return Article(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      url: url,
      publishedAt: DateTime.tryParse(publishedAt),
    );
  }
}

@freezed
abstract class ArticlesApiResponse with _$ArticlesApiResponse {
  // @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ArticlesApiResponse({
    String status,
    int totalResults,
    List<ArticleApiModel> articles,
  }) = _ArticlesApiResponse;

  factory ArticlesApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticlesApiResponseFromJson(json);
}
