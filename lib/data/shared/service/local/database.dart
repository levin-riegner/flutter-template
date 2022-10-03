import 'package:flutter_template/data/article/service/local/model/article_db_model.dart';
import 'package:isar/isar.dart';

abstract class Database {
  static Future<Isar> init() async {
    // Register all the model adapters here 👇
    return await Isar.open([
      ArticleDbModelSchema,
    ]);
  }
}
