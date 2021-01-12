import 'dart:convert';

import 'package:flutter_template/data/article/service/local/model/article_db_model.dart';
import 'package:flutter_template/data/common/service/secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class Database {
  // Hive Objects TypeId (Do not reuse the same value)
  static const int ArticleHiveType = 0;
  static const String ArticleBox = "articles";

  static Future<void> init(SecureStorage secureStorage) async {
    await Hive.initFlutter();
    await Database.setupEncryption(secureStorage);
    // Register all the model adapters here 👇
    Hive.registerAdapter<ArticleDbModel>(ArticleDbModelAdapter());
  }

  // Ensures or sets the database encryption key
  static Future<void> setupEncryption(SecureStorage secureStorage) async {
    if (secureStorage == null) return;
    final containsEncryptionKey = await secureStorage.containsDatabaseKey();
    if (!containsEncryptionKey) {
      final key = Hive.generateSecureKey();
      await secureStorage.saveDatabaseKey(base64UrlEncode(key));
    }
  }

  /// Returns current encryption cipher for database
  static Future<HiveCipher> getEncryptionCipher(
      SecureStorage secureStorage) async {
    if (secureStorage == null) return null;
    final encryptionKey =
        base64Url.decode(await secureStorage.getDatabaseKey());
    return HiveAesCipher(encryptionKey);
  }
}
