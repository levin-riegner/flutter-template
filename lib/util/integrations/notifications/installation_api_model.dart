import 'package:json_annotation/json_annotation.dart';

part 'installation_api_model.g.dart';

@JsonSerializable(includeIfNull: true)
class InstallationApiModel {
  final String? fcmToken;
  final InstallationApiDeviceType? deviceType;
  final String? timeZone;
  final String? appIdentifier;
  final String? appName;
  final String? appVersion;
  final String? osVersion;
  final String? locale;
  final List<String>? topicNames;

  const InstallationApiModel({
    required this.fcmToken,
    this.deviceType,
    this.appIdentifier,
    this.appName,
    this.appVersion,
    this.osVersion,
    this.locale,
    this.topicNames,
    this.timeZone,
  });

  factory InstallationApiModel.fromJson(Map<String, dynamic> json) =>
      _$InstallationApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$InstallationApiModelToJson(this);
}

@JsonEnum()
enum InstallationApiDeviceType {
  ios,
  android,
  ;
}
