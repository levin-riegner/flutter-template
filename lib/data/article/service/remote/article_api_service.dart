import 'package:dio/dio.dart';
import 'package:swiss_ai/data/article/service/remote/model/article_api_model.dart';
import 'package:swiss_ai/data/shared/service/remote/api_response_mapper.dart';
import 'package:swiss_ai/data/shared/service/remote/endpoints.dart';

class ArticleApiService with ApiResponseMapper {
  final Dio client;

  ArticleApiService(this.client);

  Future<ArticlesApiResponse> getArticles(String query) async {
    try {
      final response = await client.get(
        Endpoints.articles,
        queryParameters: {"q": query},
      );
      return ArticlesApiResponse.fromJson(response.data);
    } catch (e, stackTrace) {
      throw mapToError(e, stackTrace);
    }
  }
}
