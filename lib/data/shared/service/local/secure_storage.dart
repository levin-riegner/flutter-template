import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Use this class to store sensitive user-data
/// that will only be persisted locally during the user session
class SecureStorage {
  final FlutterSecureStorage _flutterSecureStorage =
      const FlutterSecureStorage();
  static const _kDatabaseKey = "databaseKey";
  static const _kUserId = "userId";
  static const _kUserAuthToken = "userAuthToken";

  // region Database Key
  Future<bool> containsDatabaseKey() async {
    if (kIsWeb) return window.localStorage.containsKey(_kDatabaseKey);

    return _flutterSecureStorage.containsKey(key: _kDatabaseKey);
  }

  Future<String?> getDatabaseKey() async {
    if (kIsWeb) return window.localStorage[_kDatabaseKey];

    return _flutterSecureStorage.read(key: _kDatabaseKey);
  }

  Future<void> saveDatabaseKey(String key) async {
    if (kIsWeb)
      window.localStorage[_kDatabaseKey] = key;
    else
      await _flutterSecureStorage.write(key: _kDatabaseKey, value: key);
  }

  // endregion

  // region User
  Future<String?> getUserId() async {
    if (kIsWeb) return window.localStorage[_kUserId];

    return _flutterSecureStorage.read(key: _kUserId);
  }

  Future<void> saveUserId(String id) async {
    if (kIsWeb)
      window.localStorage[_kUserId] = id;
    else
      await _flutterSecureStorage.write(key: _kUserId, value: id);
  }

  Future<String?> getUserAuthToken() async {
    if (kIsWeb) return window.localStorage[_kUserAuthToken];

    return _flutterSecureStorage.read(key: _kUserAuthToken);
  }

  Future<void> saveUserAuthToken(String token) async {
    if (kIsWeb)
      window.localStorage[_kUserAuthToken] = token;
    else
      await _flutterSecureStorage.write(key: _kUserAuthToken, value: token);
  }

  // endregion

  Future<void> deleteAll() async {
    if (kIsWeb)
      window.localStorage.clear();
    else
      await _flutterSecureStorage.deleteAll();
  }
}
