import 'package:dio/dio.dart';
import 'package:flutter_template/data/auth/service/remote/model/auth_api_error.dart';
import 'package:flutter_template/data/auth/service/remote/model/create_account/create_account_api_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/create_account/create_account_request_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/forgot_password_confirm/forgot_password_confirm_request_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/forgot_password_request/forgot_password_request_request_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/login/login_api_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/login/login_request_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/refresh_token/refresh_token_api_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/refresh_token/refresh_token_request_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/user_confirm/user_confirm_api_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/user_confirm/user_confirm_request_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/user_delete/user_delete_api_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/user_delete/user_delete_request_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/user_disable/user_disable_api_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/user_disable/user_disable_request_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/user_update/user_update_api_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/user_update/user_update_request_model.dart';
import 'package:flutter_template/data/shared/service/remote/api_response_mapper.dart';
import 'package:flutter_template/data/shared/service/remote/endpoints.dart';

class AuthApiService with ApiResponseMapper {
  final Dio client;

  AuthApiService(this.client);

  Future<ResponseType> _runThrowable<ResponseType>(Function action) async {
    try {
      return await action();
    } on DioException catch (e) {
      final error = AuthApiError.fromJson(e.response?.data);

      throw error.toDomain();
    } catch (e, stackTrace) {
      throw mapToError(e, stackTrace);
    }
  }

  Future<CreateAccountApiModel> createAccount(
    CreateAccountRequestModel request,
  ) =>
      _runThrowable(
        () async {
          final response = await client.post(
            AuthEndpoints.userRegister,
            data: request.toJson(),
          );

          return CreateAccountApiModel.fromJson(response.data);
        },
      );

  Future<UserUpdateApiModel> updateUser(
    UserUpdateRequestModel request,
  ) =>
      _runThrowable(
        () async {
          final response = await client.post(
            AuthEndpoints.userUpdate,
          );

          return UserUpdateApiModel.fromJson(response.data);
        },
      );

  Future<UserDeleteApiModel> deleteUser(
    UserDeleteRequestModel request,
  ) =>
      _runThrowable(
        () async {
          final response = await client.post(
            AuthEndpoints.userDelete,
          );

          return UserDeleteApiModel.fromJson(response.data);
        },
      );

  Future<UserDisableApiModel> disableUser(
    UserDisableRequestModel request,
  ) =>
      _runThrowable(
        () async {
          final response = await client.post(
            AuthEndpoints.userDisable,
          );

          return UserDisableApiModel.fromJson(response.data);
        },
      );

  Future<UserConfirmApiModel> confirmUser(
    UserConfirmRequestModel request,
  ) =>
      _runThrowable(
        () async {
          final response = await client.post(
            AuthEndpoints.userConfirm,
            data: request.toJson(),
          );

          return UserConfirmApiModel.fromJson(response.data);
        },
      );

  Future<LoginApiModel> login(
    LoginRequestModel request,
  ) =>
      _runThrowable(
        () async {
          final response = await client.post(
            AuthEndpoints.userLogin,
            data: request.toJson(),
          );

          return LoginApiModel.fromJson(response.data);
        },
      );

  Future<RefreshTokenApiModel> refreshToken(
    RefreshTokenRequestModel request,
  ) =>
      _runThrowable(
        () async {
          final response = await client.post(
            AuthEndpoints.userRefreshToken,
          );

          return RefreshTokenApiModel.fromJson(response.data);
        },
      );

  Future<bool> sendForgotPasswordRequest(
    ForgotPasswordRequestRequestModel request,
  ) =>
      _runThrowable(
        () async {
          final response = await client.post(
            AuthEndpoints.userForgotPasswordRequest,
          );

          return response.statusCode == 200;
        },
      );

  Future<bool> confirmForgotPasswordRequest(
    ForgotPasswordConfirmRequestModel request,
  ) =>
      _runThrowable(
        () async {
          final response = await client.post(
            AuthEndpoints.userForgotPasswordConfirm,
          );

          return response.statusCode == 200;
        },
      );
}
