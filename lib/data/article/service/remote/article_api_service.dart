import 'package:flutter_template/data/article/model/article.dart';
import 'package:flutter_template/data/util/endpoints.dart';

// TODO: HTTP
class ArticleApiService {
  final Endpoints _endpoints;

  ArticleApiService(this._endpoints) : assert(_endpoints != null);

  Future<List<Article>> getArticles() async {
    return [];
  }
}
