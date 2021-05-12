import 'dart:convert';

import 'package:flutter_template/data/article/model/article.dart';
import 'package:flutter_template/data/article/repository/article_repository.dart';
import 'package:flutter_template/data/article/service/remote/model/article_api_model.dart';
import 'package:flutter_template/data/util/mock.dart';

class ArticleMockRepository implements ArticleRepository {
  @override
  Future<List<Article>> getArticles(String query, {bool? forceRefresh}) async {
    await Future.delayed(Mock.mockConfig.ioDelay);
    if (Mock.mockConfig.errorAllResponses) throw Exception("Mock Exception");
    if (Mock.mockConfig.emptyResponses) return [];

    final json = await (Mock.loadJsonFile("articles_response.json"));
    return ArticlesApiResponse.fromJson(json)
        .articles!
        .map((e) => e.toArticle())
        .toList();
  }
}
