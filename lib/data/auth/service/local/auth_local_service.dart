import 'package:flutter_template/data/shared/service/local/secure_storage.dart';
import 'package:logging_flutter/logging_flutter.dart';

class AuthLocalService {
  final SecureStorage _secureStorage;

  AuthLocalService(this._secureStorage);

  Future<bool> get isSessionAvailable async {
    try {
      final userToken = await _secureStorage.getUserAuthToken();

      return userToken != null;
    } on Exception catch (e, stackTrace) {
      Flogger.e(
        "Auth local service error: $e",
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<String?> get userAuthToken {
    try {
      return _secureStorage.getUserAuthToken();
    } on Exception catch (e, stackTrace) {
      Flogger.e(
        "Auth local service error: $e",
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<String?> get userId {
    try {
      return _secureStorage.getUserId();
    } catch (e, stackTrace) {
      Flogger.e(
        "Auth local service error: $e",
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<String?> get userEmail {
    try {
      return _secureStorage.getUserEmail();
    } catch (e, stackTrace) {
      Flogger.e(
        "Auth local service error: $e",
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<void> saveUserAuthToken(String id) {
    try {
      return _secureStorage.saveUserAuthToken(id);
    } on Exception catch (e, stackTrace) {
      Flogger.e(
        "Auth local service error: $e",
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<void> saveUserId(String id) {
    try {
      return _secureStorage.saveUserId(id);
    } catch (e, stackTrace) {
      Flogger.e(
        "Auth local service error: $e",
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<void> saveUserEmail(String email) {
    try {
      return _secureStorage.saveUserEmail(email);
    } catch (e, stackTrace) {
      Flogger.e(
        "Auth local service error: $e",
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  Future<void> clearSession() {
    try {
      return _secureStorage.deleteAll();
    } on Exception catch (e, stackTrace) {
      Flogger.e(
        "Auth local service error: $e",
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }
}
