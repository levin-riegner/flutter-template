import 'package:flutter_template/data/article/model/article.dart';
import 'package:flutter_template/data/shared/service/local/database.dart';
import 'package:hive/hive.dart';

part 'article_db_model.g.dart';

@HiveType(typeId: Database.ArticleHiveType)
class ArticleDbModel extends HiveObject {
  // Never re-use the same index for new fields
  // https://docs.hivedb.dev/#/custom-objects/generate_adapter?id=updating-a-class
  static const int _titleIndex = 0;
  static const int _descriptionIndex = 1;
  static const int _imageUrlIndex = 2;
  static const int _urlIndex = 3;
  static const int _publishedAtIndex = 4;

  @HiveField(_titleIndex)
  String? title;
  @HiveField(_descriptionIndex)
  String? description;
  @HiveField(_imageUrlIndex)
  String? imageUrl;
  @HiveField(_urlIndex)
  String? url;
  @HiveField(_publishedAtIndex)
  int? publishedAt;

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
      publishedAt: publishedAt!= null ? DateTime.fromMillisecondsSinceEpoch(publishedAt!) : null,
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
}
