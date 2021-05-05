import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _flutterSecureStorage =
      const FlutterSecureStorage();
  static const _kDatabaseKey = "databaseKey";
  static const _kUserId = "userId";
  static const _kUserAuthToken = "userAuthToken";

  // region Database Key
  Future<bool> containsDatabaseKey() async {
    return _flutterSecureStorage.containsKey(key: _kDatabaseKey);
  }

  Future<String?> getDatabaseKey() async {
    return _flutterSecureStorage.read(key: _kDatabaseKey);
  }

  Future<void> saveDatabaseKey(String key) async {
    await _flutterSecureStorage.write(key: _kDatabaseKey, value: key);
  }

  // endregion

  // region User
  Future<String?> getUserId() async {
    return _flutterSecureStorage.read(key: _kUserId);
  }

  Future<void> saveUserId(String id) async {
    await _flutterSecureStorage.write(key: _kUserId, value: id);
  }

  Future<String?> getUserAuthToken() async {
    return _flutterSecureStorage.read(key: _kUserAuthToken);
  }

  Future<void> saveUserAuthToken(String token) async {
    await _flutterSecureStorage.write(key: _kUserAuthToken, value: token);
  }

  // endregion

  Future<void> deleteAll() async {
    await _flutterSecureStorage.deleteAll();
  }
}
