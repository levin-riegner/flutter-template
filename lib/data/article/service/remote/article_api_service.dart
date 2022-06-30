import 'package:dio/dio.dart';
import 'package:flutter_template/data/shared/service/remote/base_api_service.dart';
import 'package:flutter_template/data/shared/service/remote/endpoints.dart';

class ArticleApiService extends BaseApiService {
  final Dio client;

  ArticleApiService(this.client);

  Future<Response<String>> getArticles(String query) {
    try {
      return client.get(
        Endpoints.articles,
        queryParameters: {"q": query},
      );
    } catch (ex) {
      throw mapToError(ex);
    }
  }

  Future<Response<String>> getArticle(String id) {
    try {
      return client.get(
        "${Endpoints.articles}/$id",
      );
    } catch (ex) {
      throw mapToError(ex);
    }
  }
}
