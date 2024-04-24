import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_confirm_request_model.g.dart';

@JsonSerializable()
class UserConfirmRequestModel extends Equatable {
  final String email;
  final String code;

  const UserConfirmRequestModel({
    required this.email,
    required this.code,
  });

  @override
  List<Object?> get props => [
        email,
        code,
      ];

  Map<String, dynamic> toJson() => _$UserConfirmRequestModelToJson(this);
}
