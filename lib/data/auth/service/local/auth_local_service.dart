import 'package:flutter_template/data/shared/service/local/secure_storage.dart';
import 'package:logging_flutter/logging_flutter.dart';

class AuthLocalService {
  final SecureStorage _secureStorage;

  AuthLocalService(this._secureStorage);

  Future<ResponseType> _runThrowable<ResponseType>(Function action) async {
    try {
      return await action();
    } catch (e, stackTrace) {
      Flogger.e(
        "Auth local service error: $e",
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<bool> get isSessionAvailable async => _runThrowable(
        () async {
          final userToken = await _secureStorage.getUserAuthToken();

          return userToken != null;
        },
      );

  Future<String?> get userId => _runThrowable(
        () => _secureStorage.getUserId(),
      );

  Future<String?> get userAuthToken => _runThrowable(
        () => _secureStorage.getUserAuthToken(),
      );

  Future<String?> get userEmail => _runThrowable(
        () => _secureStorage.getUserEmail(),
      );

  Future<void> saveUserAuthToken(String token) => _runThrowable(
        () => _secureStorage.saveUserAuthToken(token),
      );

  Future<void> saveUserId(String id) => _runThrowable(
        () => _secureStorage.saveUserId(id),
      );

  Future<void> saveUserEmail(String email) => _runThrowable(
        () => _secureStorage.saveUserEmail(email),
      );

  Future<void> clearSession() => _runThrowable(
        () => _secureStorage.deleteAll(),
      );
}
