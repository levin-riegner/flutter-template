import 'package:flutter_template/data/article/service/local/model/article_db_model.dart';
import 'package:isar/isar.dart';

class ArticleDbService {
  final IsarCollection<ArticleDbModel> _collection;

  ArticleDbService(this._collection);

  Future<List<ArticleDbModel>> getArticles(String? query) async {
    if (query != null && query.isNotEmpty) {
      return _collection
          .filter()
          .titleContains(query, caseSensitive: false)
          .or()
          .descriptionContains(query, caseSensitive: false)
          .findAll();
    } else {
      return _collection.where().findAll();
    }
  }

  Stream<List<ArticleDbModel>> articles() {
    return _collection
        .watchLazy(fireImmediately: true)
        .asyncMap((_) => _collection.where().findAll());
  }

  Future<void> saveArticles(List<ArticleDbModel> articles) async {
    await _collection.isar.writeTxn(() async {
      await _collection.putAll(articles);
    });
  }
}
