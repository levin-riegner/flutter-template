import 'package:drift/drift.dart';
import 'package:flutter_template/data/article/model/article.dart';
import 'package:flutter_template/data/shared/service/local/database.dart';

extension ArticleDbModelMapper on ArticleDbModel {
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
}

extension ArticleToDb on Article {
  ArticlesCompanion toDbCompanion() {
    return ArticlesCompanion.insert(
      title: Value(title),
      description: Value(description),
      imageUrl: Value(imageUrl),
      url: Value(url),
      publishedAt: Value(publishedAt?.millisecondsSinceEpoch),
    );
  }
}
