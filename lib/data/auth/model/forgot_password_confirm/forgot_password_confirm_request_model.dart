import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_confirm_request_model.g.dart';

@JsonSerializable()
class ForgotPasswordConfirmRequestModel extends Equatable {
  final String email;
  final String password;
  final String code;

  const ForgotPasswordConfirmRequestModel({
    required this.email,
    required this.password,
    required this.code,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        code,
      ];

  Map<String, dynamic> toJson() =>
      _$ForgotPasswordConfirmRequestModelToJson(this);
}
