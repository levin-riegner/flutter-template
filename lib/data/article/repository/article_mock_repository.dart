import 'dart:convert';

import 'package:flutter_template/data/article/model/article.dart';
import 'package:flutter_template/data/article/repository/article_repository.dart';
import 'package:flutter_template/data/article/service/remote/model/article_api_model.dart';
import 'package:flutter_template/data/util/mock.dart';

class ArticleMockRepository implements ArticleRepository {
  @override
  Future<List<Article>> getArticles() async {
    final articlesResponseJson = await Mock.getArticlesResponse();
    final articlesResponse =
        ArticlesApiResponse.fromJson(jsonDecode(articlesResponseJson));
    return articlesResponse.articles.map((e) => e.toArticle()).toList();
  }
}
