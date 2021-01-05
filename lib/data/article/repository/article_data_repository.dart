import 'package:flutter_template/data/article/model/article.dart';
import 'package:flutter_template/data/article/repository/article_repository.dart';
import 'package:flutter_template/data/article/service/local/article_db_service.dart';
import 'package:flutter_template/data/article/service/remote/article_api_service.dart';

class ArticleDataRepository implements ArticleRepository {
  final ArticleApiService apiService;
  final ArticleDbService dbService;

  ArticleDataRepository(
    this.apiService,
    this.dbService,
  )   : assert(apiService != null),
        assert(dbService != null);

  @override
  Future<List<Article>> getArticles(String query, {bool forceRefresh}) async {
    final dbArticles = await dbService.getArticles(query);
    if (dbArticles.isNotEmpty && !forceRefresh) {
      return dbArticles;
    } else {
      try {
        final articlesResponse = await apiService.getArticles(query);
        if(articlesResponse.isSuccessful) {
          final articles = articlesResponse.body.articles.map((e) => e.toArticle()).toList();
          await dbService.saveArticles(articles);
          return articles;
        } else {
          // TODO: Parse Error codes
          print(articlesResponse.error);
          return [];
        }
      } catch (e) {
        // TODO: Convert Exception to repository exception
        print("ERROR - $e");
        throw e;
      }
    }
  }
}
