import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_request_model.g.dart';

@JsonSerializable()
class RefreshTokenRequestModel extends Equatable {
  final String email;
  final String token;

  const RefreshTokenRequestModel({
    required this.email,
    required this.token,
  });

  @override
  List<Object?> get props => [
        email,
        token,
      ];

  Map<String, dynamic> toJson() => _$RefreshTokenRequestModelToJson(this);
}
