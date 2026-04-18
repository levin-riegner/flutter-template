import 'package:color_picker/data/article/service/local/model/article_db_model.dart';
import 'package:isar/isar.dart';

class ArticleDbService {
  final AppDatabase _db;

  ArticleDbService(this._db);

  Future<List<ArticleDbModel>> getArticles(String? query) async {
    if (query != null && query.isNotEmpty) {
      final lowerQuery = '%${query.toLowerCase()}%';
      return (_db.select(_db.articles)
            ..where((a) =>
                a.title.lower().like(lowerQuery) |
                a.description.lower().like(lowerQuery)))
          .get();
    } else {
      return _db.select(_db.articles).get();
    }
  }

  Stream<List<ArticleDbModel>> articles() {
    return _db.select(_db.articles).watch();
  }

  Future<void> saveArticles(List<ArticlesCompanion> articles) async {
    await _db.batch((batch) {
      batch.insertAll(_db.articles, articles, mode: InsertMode.insertOrReplace);
    });
  }
}
