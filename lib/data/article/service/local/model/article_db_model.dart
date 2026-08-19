import 'package:swiss_ai/data/article/model/article.dart';

/// Plain-Dart representation of an Article as persisted by [ArticleDbService].
///
/// This deliberately replaces the broken drift/isar table scaffolding that
/// shipped in the template (which imported `package:isar/isar.dart` without
/// declaring the dependency). The app now persists through a pure-Dart
/// in-memory store so the unit tests run on the host without native plugins.
class ArticleDbModel {
  final String? id;
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? url;
  final int? publishedAt;

  const ArticleDbModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.url,
    required this.publishedAt,
  });

  /// Maps a persisted row back to the domain [Article].
  Article toArticle() {
    return Article(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      url: url,
      publishedAt: publishedAt != null
          ? DateTime.fromMillisecondsSinceEpoch(publishedAt!)
          : null,
    );
  }

  /// Maps a domain [Article] into a row to persist.
  factory ArticleDbModel.fromArticle(Article article) {
    return ArticleDbModel(
      id: article.id,
      title: article.title,
      description: article.description,
      imageUrl: article.imageUrl,
      url: article.url,
      publishedAt: article.publishedAt?.millisecondsSinceEpoch,
    );
  }
}
