import 'package:flutter_template/data/article/model/article.dart';

abstract class ArticleRepository {
  Future<List<Article>> getArticles(String query, {bool? forceRefresh});
}