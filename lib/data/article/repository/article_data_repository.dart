import 'package:flutter_template/data/article/model/article.dart';
import 'package:flutter_template/data/article/model/article_data_error.dart';
import 'package:flutter_template/data/article/repository/article_repository.dart';
import 'package:flutter_template/data/article/service/local/article_db_service.dart';
import 'package:flutter_template/data/article/service/local/model/article_db_model.dart';
import 'package:flutter_template/data/article/service/remote/article_api_service.dart';
import 'package:logging_flutter/flogger.dart';

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
    final dbArticles =
        (await dbService.getArticles(query)).map((e) => e.toArticle()).toList();
    if (dbArticles.isNotEmpty && !forceRefresh) {
      return dbArticles;
    } else {
      final articlesResponse = await apiService.getArticles(query);
      if (articlesResponse.isSuccessful) {
        final articles =
            articlesResponse.body.articles.map((e) => e.toArticle()).toList();
        await dbService
            .saveArticles(articles.map(ArticleDbModel.fromArticle).toList());
        return articles;
      } else {
        Flogger.d("Error getting articles", object: articlesResponse.error);
        switch (articlesResponse.statusCode) {
          case 403:
            throw SubscriptionExpired();
          case 404:
            throw NotFound();
          default:
            throw Unknown(articlesResponse.error);
        }
      }
    }
  }
}
