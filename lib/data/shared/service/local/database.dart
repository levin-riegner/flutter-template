import 'package:flutter_template/data/article/service/local/model/article_db_model.dart';
import 'package:isar/isar.dart';

abstract class Database {
  static Future<Isar> init({
    required String directory,
  }) async {
    // Register all the model adapters here 👇
    return await Isar.open(
      [
        ArticleDbModelSchema,
      ],
      directory: directory,
    );
  }

  /// FNV-1a 64bit hash algorithm optimized for Dart Strings
  static int fastHash(String string) {
    var hash = 0xcbf29ce484222325;

    var i = 0;
    while (i < string.length) {
      final codeUnit = string.codeUnitAt(i++);
      hash ^= codeUnit >> 8;
      hash *= 0x100000001b3;
      hash ^= codeUnit & 0xFF;
      hash *= 0x100000001b3;
    }

    return hash;
  }
}
