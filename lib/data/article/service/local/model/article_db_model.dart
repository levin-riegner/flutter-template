import 'package:color_picker/data/article/model/article.dart';
import 'package:isar/isar.dart';

@DataClassName('ArticleDbModel')
class Articles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get url => text().nullable()();
  IntColumn get publishedAt => integer().nullable()();
}
