import 'package:dio/dio.dart';
import 'package:flutter_template/data/auth/model/auth_data_error.dart';
import 'package:flutter_template/data/auth/model/create_account/create_account_request_model.dart';
import 'package:flutter_template/data/auth/model/forgot_password_confirm/forgot_password_confirm_request_model.dart';
import 'package:flutter_template/data/auth/model/forgot_password_request/forgot_password_request_request_model.dart';
import 'package:flutter_template/data/auth/model/login/login_request_model.dart';
import 'package:flutter_template/data/auth/model/refresh_token/refresh_token_request_model.dart';
import 'package:flutter_template/data/auth/model/user_confirm/user_confirm_request_model.dart';
import 'package:flutter_template/data/auth/model/user_confirm_request/user_confirm_request_request_model.dart';
import 'package:flutter_template/data/auth/model/user_delete/user_delete_request_model.dart';
import 'package:flutter_template/data/auth/model/user_disable/user_disable_request_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/auth_api_error.dart';
import 'package:flutter_template/data/auth/service/remote/model/create_account_api_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/login_api_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/refresh_token_api_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/user_confirm_api_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/user_delete_api_model.dart';
import 'package:flutter_template/data/auth/service/remote/model/user_disable_api_model.dart';
import 'package:flutter_template/data/shared/service/remote/api_response_mapper.dart';
import 'package:flutter_template/data/shared/service/remote/endpoints.dart';
import 'package:flutter_template/util/extensions/string_extension.dart';

class AuthApiService with ApiResponseMapper {
  final Dio client;

  AuthApiService(this.client);

  Future<CreateAccountApiModel> createAccount(
    CreateAccountRequestModel request,
  ) async {
    try {
      final response = await client.post(
        AuthEndpoints.userRegister,
        data: request.toJson(),
      );

      final apiModel = CreateAccountApiModel.fromJson(response.data);

      if (apiModel.userId.isNullOrEmpty) {
        throw NotAuthorized();
      }

      return apiModel;
    } on DioException catch (e) {
      final error = AuthApiError.fromJson(e.response?.data);

      throw error.toDomain();
    } catch (e, stackTrace) {
      throw mapToError(e, stackTrace);
    }
  }

  Future<UserDeleteApiModel> deleteUser(
    UserDeleteRequestModel request,
  ) async {
    try {
      final response = await client.post(
        AuthEndpoints.userDelete,
      );

      return UserDeleteApiModel.fromJson(response.data);
    } on DioException catch (e) {
      final error = AuthApiError.fromJson(e.response?.data);

      throw error.toDomain();
    } catch (e, stackTrace) {
      throw mapToError(e, stackTrace);
    }
  }

  Future<UserDisableApiModel> disableUser(
    UserDisableRequestModel request,
  ) async {
    try {
      final response = await client.post(
        AuthEndpoints.userDisable,
      );

      return UserDisableApiModel.fromJson(response.data);
    } on DioException catch (e) {
      final error = AuthApiError.fromJson(e.response?.data);

      throw error.toDomain();
    } catch (e, stackTrace) {
      throw mapToError(e, stackTrace);
    }
  }

  Future<void> sendConfirmUserRequest(
    UserConfirmRequestRequestModel request,
  ) async {
    try {
      await client.post(
        AuthEndpoints.userConfirmRequest,
        data: request.toJson(),
      );
    } on DioException catch (e) {
      final error = AuthApiError.fromJson(e.response?.data);

      throw error.toDomain();
    } catch (e, stackTrace) {
      throw mapToError(e, stackTrace);
    }
  }

  Future<UserConfirmApiModel> confirmUser(
    UserConfirmRequestModel request,
  ) async {
    try {
      final response = await client.post(
        AuthEndpoints.userConfirm,
        data: request.toJson(),
      );

      return UserConfirmApiModel.fromJson(response.data);
    } on DioException catch (e) {
      final error = AuthApiError.fromJson(e.response?.data);

      throw error.toDomain();
    } catch (e, stackTrace) {
      throw mapToError(e, stackTrace);
    }
  }

  Future<LoginApiModel> login(
    LoginRequestModel request,
  ) async {
    try {
      final response = await client.post(
        AuthEndpoints.userLogin,
        data: request.toJson(),
      );

      final apiModel = LoginApiModel.fromJson(response.data);

      if (apiModel.token.isNullOrEmpty) {
        throw NotAuthorized();
      }

      return apiModel;
    } on DioException catch (e) {
      final error = AuthApiError.fromJson(e.response?.data);

      throw error.toDomain();
    } catch (e, stackTrace) {
      throw mapToError(e, stackTrace);
    }
  }

  Future<RefreshTokenApiModel> refreshToken(
    RefreshTokenRequestModel request,
  ) async {
    try {
      final response = await client.post(
        AuthEndpoints.userRefreshToken,
      );

      return RefreshTokenApiModel.fromJson(response.data);
    } on DioException catch (e) {
      final error = AuthApiError.fromJson(e.response?.data);

      throw error.toDomain();
    } catch (e, stackTrace) {
      throw mapToError(e, stackTrace);
    }
  }

  Future<void> sendForgotPasswordRequest(
    ForgotPasswordRequestRequestModel request,
  ) async {
    try {
      await client.post(
        AuthEndpoints.userForgotPasswordRequest,
        data: request.toJson(),
      );
    } on DioException catch (e) {
      final error = AuthApiError.fromJson(e.response?.data);

      throw error.toDomain();
    } catch (e, stackTrace) {
      throw mapToError(e, stackTrace);
    }
  }

  Future<void> confirmForgotPasswordRequest(
    ForgotPasswordConfirmRequestModel request,
  ) async {
    try {
      await client.post(
        AuthEndpoints.userForgotPasswordConfirm,
        data: request.toJson(),
      );
    } on DioException catch (e) {
      final error = AuthApiError.fromJson(e.response?.data);

      throw error.toDomain();
    } catch (e, stackTrace) {
      throw mapToError(e, stackTrace);
    }
  }
}
