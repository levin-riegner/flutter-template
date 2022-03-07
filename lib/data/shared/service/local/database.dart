import 'package:flutter_template/data/article/service/local/model/article_db_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class Database {
  // Hive Objects TypeId (Do not reuse the same value)
  static const int ArticleHiveType = 0;
  static const String ArticleBox = "articles";

  static Future<void> init() async {
    await Hive.initFlutter();
    // Register all the model adapters here 👇
    Hive.registerAdapter<ArticleDbModel>(ArticleDbModelAdapter());
  }

// No longer using encryption
// See: https://github.com/hivedb/hive/issues/263
// Ensures or sets the database encryption key
// static Future<void> _setupEncryption(SecureStorage secureStorage) async {
//   final containsEncryptionKey = await secureStorage.containsDatabaseKey();
//   if (!containsEncryptionKey) {
//     final key = Hive.generateSecureKey();
//     await secureStorage.saveDatabaseKey(base64UrlEncode(key));
//   }
// }
//
// /// Returns current encryption cipher for database
// static Future<HiveCipher> getEncryptionCipher(
//     SecureStorage secureStorage) async {
//   final String? key = await secureStorage.getDatabaseKey();
//   if (key == null) {
//     await _setupEncryption(secureStorage);
//   }
//   final encryptionKey =
//       base64Url.decode((await secureStorage.getDatabaseKey())!);
//   return HiveAesCipher(encryptionKey);
// }
}
