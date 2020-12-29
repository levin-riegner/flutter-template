import 'package:flutter_template/data/article/model/article.dart';
import 'package:flutter_template/data/article/repository/article_repository.dart';

class ArticleMockRepository implements ArticleRepository {
  @override
  Future<List<Article>> getArticles() async {
    return [Article(), Article()];
  }

}