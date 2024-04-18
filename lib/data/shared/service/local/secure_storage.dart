import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Use this class to store sensitive user-data
/// that will only be persisted locally during the user session
class SecureStorage {
  final FlutterSecureStorage _flutterSecureStorage =
      const FlutterSecureStorage();
  static const _kUserId = "userId";
  static const _kUserAuthToken = "userAuthToken";
  static const _kUserEmail = "userEmail";

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

  Future<String?> getUserEmail() async {
    return _flutterSecureStorage.read(key: _kUserEmail);
  }

  Future<void> saveUserEmail(String email) async {
    await _flutterSecureStorage.write(key: _kUserEmail, value: email);
  }
  // endregion

  Future<void> deleteAll() async {
    await _flutterSecureStorage.deleteAll();
  }
}
