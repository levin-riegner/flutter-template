import 'package:flutter_template/data/article/model/article.dart';

class ArticleDbService {

  final String _dbName;

  ArticleDbService(this._dbName): assert(_dbName != null);
  
  Future<List<Article>> getArticles() async {
    return [];
  }

  Future<void> saveArticles() async {
    return;
  }

}