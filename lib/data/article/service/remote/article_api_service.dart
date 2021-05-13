import 'package:chopper/chopper.dart';
import 'package:flutter_template/data/article/service/remote/model/article_api_model.dart';
import 'package:flutter_template/data/shared/service/remote/endpoints.dart';

part 'article_api_service.chopper.dart';

@ChopperApi()
abstract class ArticleApiService extends ChopperService {

  static ArticleApiService create(ChopperClient client) =>
      _$ArticleApiService(client);

  @Get(path: Endpoints.articles)
  Future<Response<ArticlesApiResponse>> getArticles(@Query("q") String query);

  @Get(path: "${Endpoints.articles}/{id}")
  Future<Response<ArticleApiModel>> getArticle(@Path() String id);
}
