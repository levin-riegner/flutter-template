import 'package:flutter_template/data/article/model/article.dart';
import 'package:flutter_template/data/article/service/local/model/article_db_model.dart';
import 'package:hive/hive.dart';

class ArticleDbService {
  final Box<ArticleDbModel> _articlesBox;

  ArticleDbService(this._articlesBox) : assert(_articlesBox != null);

  Future<List<ArticleDbModel>> getArticles(String query) async {
    return _articlesBox.values
        .where((e) => query != null
            ? e.title.contains(query) || e.description.contains(query)
            : true)
        .toList();
  }

  Future<void> saveArticles(List<ArticleDbModel> articles) async {
    _articlesBox.addAll(articles);
  }

}
