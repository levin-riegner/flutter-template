import 'package:flutter_template/data/article/model/article.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_api_model.g.dart';

// @JsonSerializable(fieldRename: FieldRename.snake)
@JsonSerializable()
class ArticleApiModel {
  final String? id;
  final String? title;
  final String? description;
  @JsonKey(name: "urlToImage")
  final String? imageUrl;
  final String? url;
  final String? publishedAt;

  const ArticleApiModel({
    this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.url,
    this.publishedAt,
  });

  factory ArticleApiModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleApiModelFromJson(json);

  Article toArticle() {
    return Article(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      url: url,
      publishedAt: publishedAt != null ? DateTime.tryParse(publishedAt!) : null,
    );
  }
}

// @JsonSerializable(fieldRename: FieldRename.snake)
@JsonSerializable()
class ArticlesApiResponse {
  final String? status;
  final int? totalResults;
  final List<ArticleApiModel>? articles;

  const ArticlesApiResponse({
    this.status,
    this.totalResults,
    this.articles,
  });

  factory ArticlesApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticlesApiResponseFromJson(json);
}
