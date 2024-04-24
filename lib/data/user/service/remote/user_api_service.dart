import 'package:dio/dio.dart';
import 'package:flutter_template/data/auth/service/remote/model/auth_api_error.dart';
import 'package:flutter_template/data/shared/service/remote/api_response_mapper.dart';
import 'package:flutter_template/data/shared/service/remote/endpoints.dart';
import 'package:flutter_template/data/user/service/remote/model/user_update/user_update_api_model.dart';
import 'package:flutter_template/data/user/service/remote/model/user_update/user_update_request_model.dart';

class UserApiService with ApiResponseMapper {
  final Dio client;

  UserApiService(this.client);

  Future<UserUpdateApiModel> updateUser(
    UserUpdateRequestModel request,
  ) async {
    try {
      final response = await client.post(
        AuthEndpoints.userUpdate,
      );

      return UserUpdateApiModel.fromJson(response.data);
    } on DioException catch (e) {
      final error = AuthApiError.fromJson(e.response?.data);

      throw error.toDomain();
    } catch (e, stackTrace) {
      throw mapToError(e, stackTrace);
    }
  }
}
