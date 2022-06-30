import 'dart:convert';

import 'package:flutter_template/data/article/model/article.dart';
import 'package:flutter_template/data/article/repository/article_repository.dart';
import 'package:flutter_template/data/article/service/local/article_db_service.dart';
import 'package:flutter_template/data/article/service/local/model/article_db_model.dart';
import 'package:flutter_template/data/article/service/remote/article_api_service.dart';
import 'package:flutter_template/data/article/service/remote/model/article_api_model.dart';
import 'package:logging_flutter/flogger.dart';

class ArticleDataRepository implements ArticleRepository {
  final ArticleApiService _apiService;
  final ArticleDbService _dbService;

  ArticleDataRepository(
    this._apiService,
    this._dbService,
  );

  @override
  Future<List<Article>> getArticles(String query, {bool? forceRefresh}) async {
    Flogger.i(
        "Getting articles for query $query. Force refresh: $forceRefresh");
    final dbArticles = (await _dbService.getArticles(query))
        .map((e) => e.toArticle())
        .toList();
    if (dbArticles.isNotEmpty && !forceRefresh!) {
      return dbArticles;
    } else {
      final articlesResponse = ArticlesApiResponse.fromJson(
          json.decode((await _apiService.getArticles(query)).data!));

      final articles =
          articlesResponse.articles?.map((e) => e.toArticle()).toList();
      if (articles != null) {
        await _dbService
            .saveArticles(articles.map(ArticleDbModel.fromArticle).toList());

        return articles;
      }

      return [];
    }
  }
}
