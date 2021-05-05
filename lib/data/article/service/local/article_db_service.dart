import 'package:flutter_template/data/article/service/local/model/article_db_model.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

class ArticleDbService {
  final Box<ArticleDbModel> _articlesBox;

  ArticleDbService(this._articlesBox);

  Future<List<ArticleDbModel>> getArticles(String? query) async {
    return _articlesBox.values
        .where((e) => query != null
            ? e.title!.contains(query) || e.description!.contains(query)
            : true)
        .toList();
  }

  Stream<List<ArticleDbModel>> articles() {
    return _articlesBox
        .watch()
        .map((event) => _articlesBox.values.toList())
        .startWith(_articlesBox.values.toList());
  }

  Future<void> saveArticles(List<ArticleDbModel> articles) async {
    await _articlesBox.addAll(articles);
  }

}
