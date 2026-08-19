import 'package:dio/dio.dart';
import 'package:swiss_ai/util/integrations/notifications/installation_api_model.dart';

class PushNotificationsApiService {
  final Dio _dio;

  final String _saveInstallationEndpoint = "/installations/save";

  const PushNotificationsApiService(this._dio);

  Future<void> saveInstallation(InstallationApiModel installation) async {
    await _dio.post(
      _saveInstallationEndpoint,
      data: installation.toJson(),
    );
  }
}
