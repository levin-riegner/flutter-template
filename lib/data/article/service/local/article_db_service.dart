import 'dart:async';

import 'package:color_picker/data/article/service/local/model/article_db_model.dart';

/// Local persistence for articles.
///
/// The template shipped this as drift/isar tables that could not compile
/// (it imported `package:isar/isar.dart` without declaring the dependency and
/// referenced a stale package name). This implementation is a pure-Dart
/// in-memory store so the architecture is testable on the host without native
/// sqlite/isar plugins. Production could swap the backing store for drift/sqlite
/// behind this same interface.
class ArticleDbService {
  final List<ArticleDbModel> _store = [];

  Future<List<ArticleDbModel>> getArticles(String? query) async {
    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      return _store
          .where((a) =>
              (a.title?.toLowerCase().contains(q) ?? false) ||
              (a.description?.toLowerCase().contains(q) ?? false))
          .toList();
    }
    return List.unmodifiable(_store);
  }

  Stream<List<ArticleDbModel>> articles() async* {
    yield List.unmodifiable(_store);
  }

  Future<void> saveArticles(List<ArticleDbModel> articles) async {
    _store
      ..clear()
      ..addAll(articles);
  }
}
