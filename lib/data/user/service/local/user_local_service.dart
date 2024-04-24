import 'package:flutter_template/data/shared/service/local/secure_storage.dart';
import 'package:logging_flutter/logging_flutter.dart';

class UserLocalService {
  final SecureStorage _secureStorage;

  UserLocalService(this._secureStorage);

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
}
