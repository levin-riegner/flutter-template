import 'package:flutter_template/data/user/model/user_update_model.dart';
import 'package:flutter_template/data/user/service/local/user_local_service.dart';
import 'package:flutter_template/data/user/service/remote/model/user_update/user_update_request_model.dart';
import 'package:flutter_template/data/user/service/remote/user_api_service.dart';
import 'package:logging_flutter/logging_flutter.dart';

class UserRepository {
  final UserApiService _apiService;
  final UserLocalService _localService;

  const UserRepository(
    this._apiService,
    this._localService,
  );

  Future<UserUpdateModel> updateUser(
    UserUpdateRequestModel request,
  ) async {
    Flogger.i("Update user account");
    final apiResponse = await _apiService.updateUser(
      request,
    );

    return apiResponse.toDomain();
  }
}
