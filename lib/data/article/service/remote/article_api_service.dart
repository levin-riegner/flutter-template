import 'package:dio/dio.dart';
import 'package:flutter_template/data/article/service/remote/model/article_api_model.dart';
import 'package:flutter_template/data/shared/service/remote/base_api_service.dart';
import 'package:flutter_template/data/shared/service/remote/endpoints.dart';

class ArticleApiService extends BaseApiService {
  final Dio client;

  ArticleApiService(this.client);

  Future<ArticlesApiResponse> getArticles(String query) async {
    try {
      final response = await client.get(
        Endpoints.articles,
        queryParameters: {"q": query},
      );
      return ArticlesApiResponse.fromJson(response.data);
    } catch (ex) {
      throw mapToError(ex);
    }
  }
}
