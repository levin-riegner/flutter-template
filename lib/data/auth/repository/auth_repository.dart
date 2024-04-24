import 'package:flutter_template/data/auth/model/auth_token_model.dart';
import 'package:flutter_template/data/auth/model/create_account/create_account_model.dart';
import 'package:flutter_template/data/auth/model/create_account/create_account_request_model.dart';
import 'package:flutter_template/data/auth/model/forgot_password_confirm/forgot_password_confirm_request_model.dart';
import 'package:flutter_template/data/auth/model/forgot_password_request/forgot_password_request_request_model.dart';
import 'package:flutter_template/data/auth/model/login/login_request_model.dart';
import 'package:flutter_template/data/auth/model/refresh_token/refresh_token_request_model.dart';
import 'package:flutter_template/data/auth/model/user_confirm/user_confirm_model.dart';
import 'package:flutter_template/data/auth/model/user_confirm/user_confirm_request_model.dart';
import 'package:flutter_template/data/auth/model/user_confirm_request/user_confirm_request_request_model.dart';
import 'package:flutter_template/data/auth/model/user_delete/user_delete_model.dart';
import 'package:flutter_template/data/auth/model/user_delete/user_delete_request_model.dart';
import 'package:flutter_template/data/auth/model/user_disable/user_disable_model.dart';
import 'package:flutter_template/data/auth/model/user_disable/user_disable_request_model.dart';
import 'package:flutter_template/data/auth/service/local/auth_local_service.dart';
import 'package:flutter_template/data/auth/service/remote/auth_api_service.dart';
import 'package:flutter_template/util/extensions/string_extension.dart';
import 'package:logging_flutter/logging_flutter.dart';

class AuthRepository {
  final AuthApiService _apiService;
  final AuthLocalService _localService;

  const AuthRepository(
    this._apiService,
    this._localService,
  );

  Future<bool> get isSessionAvailable async {
    return _localService.isSessionAvailable;
  }

  Future<String?> get userToken {
    return _localService.userAuthToken;
  }

  Future<String?> get userId {
    Flogger.i("Get User ID");
    return _localService.userId;
  }

  Future<String?> get userEmail {
    Flogger.i("Get User Email");
    return _localService.userEmail;
  }

  Future<void> _saveUserToken(
    String token,
  ) async {
    Flogger.i("Save User Auth Token");
    return await _localService.saveUserAuthToken(
      token,
    );
  }

  Future<void> _saveUserId(
    String id,
  ) async {
    Flogger.i("Save User ID");
    return await _localService.saveUserId(
      id,
    );
  }

  Future<void> _saveUserEmail(
    String email,
  ) async {
    Flogger.i("Save User Email");
    return await _localService.saveUserEmail(
      email,
    );
  }

  Future<CreateAccountModel> createAccountWithEmailAndPassword(
    CreateAccountRequestModel request,
  ) async {
    Flogger.i("Register with email and password credentials");
    final apiResponse = await _apiService.createAccount(
      request,
    );

    await Future.wait([
      if (!apiResponse.userId.isNullOrEmpty) _saveUserId(apiResponse.userId!),
      _saveUserEmail(request.email),
    ]);

    return apiResponse.toDomain();
  }

  Future<AuthTokenModel> loginWithEmailAndPassword(
    LoginRequestModel request,
  ) async {
    Flogger.i("Sign in with email and password credentials");
    final apiResponse = await _apiService.login(
      request,
    );

    await Future.wait([
      if (!apiResponse.token.isNullOrEmpty) _saveUserToken(apiResponse.token!),
      _saveUserEmail(request.email),
    ]);

    return apiResponse.toDomain();
  }

  Future<UserDeleteModel> deleteUser(
    UserDeleteRequestModel request,
  ) async {
    Flogger.i("Delete user account");
    final apiResponse = await _apiService.deleteUser(
      request,
    );

    return apiResponse.toDomain();
  }

  Future<UserDisableModel> disableUser(
    UserDisableRequestModel request,
  ) async {
    Flogger.i("Disable user account");
    final apiResponse = await _apiService.disableUser(
      request,
    );

    return apiResponse.toDomain();
  }

  Future<void> sendConfirmUserRequest(
    UserConfirmRequestRequestModel request,
  ) async {
    Flogger.i("Send confirm user request");
    return await _apiService.sendConfirmUserRequest(
      request,
    );
  }

  Future<UserConfirmModel> confirmUser(
    UserConfirmRequestModel request,
  ) async {
    Flogger.i("Confirm user account");
    final apiResponse = await _apiService.confirmUser(
      request,
    );

    return apiResponse.toDomain();
  }

  Future<AuthTokenModel> refreshToken(
    RefreshTokenRequestModel request,
  ) async {
    Flogger.i("Refresh user auth token");
    final apiResponse = await _apiService.refreshToken(
      request,
    );

    return apiResponse.toDomain();
  }

  Future<void> sendForgotPasswordRequest(
    ForgotPasswordRequestRequestModel request,
  ) async {
    Flogger.i("Send forgot password request");
    return await _apiService.sendForgotPasswordRequest(
      request,
    );
  }

  Future<void> confirmForgotPasswordRequest(
    ForgotPasswordConfirmRequestModel request,
  ) async {
    Flogger.i("Confirm forgot password request");
    return await _apiService.confirmForgotPasswordRequest(
      request,
    );
  }

  Future<void> clearSession() async {
    Flogger.i("Clear user session");
    return await _localService.clearSession();
  }
}
