// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$ArticleApiService extends ArticleApiService {
  _$ArticleApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ArticleApiService;

  @override
  Future<Response<ArticlesApiResponse>> getArticles(String query) {
    final $url = '/everything';
    final $params = <String, dynamic>{'q': query};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<ArticlesApiResponse, ArticlesApiResponse>($request);
  }

  @override
  Future<Response<ArticleApiModel>> getArticle(String id) {
    final $url = '/everything/$id';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<ArticleApiModel, ArticleApiModel>($request);
  }
}
