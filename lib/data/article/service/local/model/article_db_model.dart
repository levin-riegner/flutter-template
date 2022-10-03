import 'package:flutter_template/data/article/model/article.dart';
import 'package:isar/isar.dart';

part 'article_db_model.g.dart';

@collection
@Name("Article")
// ignore: must_be_immutable
class ArticleDbModel {
  Id id = Isar.autoIncrement;
  @Index()
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? url;
  final int? publishedAt;

  ArticleDbModel({
    this.title,
    this.description,
    this.imageUrl,
    this.url,
    this.publishedAt,
  });

  Article toArticle() {
    return Article(
      id: null,
      title: title,
      description: description,
      imageUrl: imageUrl,
      url: url,
      publishedAt: publishedAt != null
          ? DateTime.fromMillisecondsSinceEpoch(publishedAt!)
          : null,
    );
  }

  static ArticleDbModel fromArticle(Article article) {
    return ArticleDbModel(
      title: article.title,
      description: article.description,
      imageUrl: article.imageUrl,
      url: article.url,
      publishedAt: article.publishedAt?.millisecondsSinceEpoch,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleDbModel &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          description == other.description &&
          imageUrl == other.imageUrl &&
          url == other.url &&
          publishedAt == other.publishedAt;

  @override
  int get hashCode =>
      title.hashCode ^
      description.hashCode ^
      imageUrl.hashCode ^
      url.hashCode ^
      publishedAt.hashCode;

  @override
  String toString() {
    return 'ArticleDbModel{title: $title, description: $description, imageUrl: $imageUrl, url: $url, publishedAt: $publishedAt}';
  }
}
