import 'package:equatable/equatable.dart';
import 'package:flutter_template/data/article/model/article.dart';
import 'package:isar/isar.dart';

part 'article_db_model.g.dart';

@collection
@Name("Article")
// ignore: must_be_immutable
class ArticleDbModel extends Equatable {
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
  List<Object?> get props => [title, description, imageUrl, url, publishedAt];
}
