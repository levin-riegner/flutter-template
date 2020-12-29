import 'package:flutter_template/data/article/model/article.dart';
import 'package:flutter_template/data/article/repository/article_repository.dart';
import 'package:flutter_template/data/article/service/local/article_db_service.dart';
import 'package:flutter_template/data/article/service/remote/article_api_service.dart';

// TODO: DB / Caching / Observables
class ArticleDataRepository implements ArticleRepository {
  final ArticleApiService apiService;
  final ArticleDbService dbService;

  ArticleDataRepository(
    this.apiService,
    this.dbService,
  )   : assert(apiService != null),
        assert(dbService != null);

  @override
  Future<List<Article>> getArticles() async {
    final dbArticles = await dbService.getArticles();
    if (dbArticles.isNotEmpty) {
      return dbArticles;
    } else {
      final apiArticles = apiService.getArticles();
      await dbService.saveArticles();
      return apiArticles;
    }
  }
}
