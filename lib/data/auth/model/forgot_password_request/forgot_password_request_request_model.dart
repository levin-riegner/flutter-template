import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_request_request_model.g.dart';

@JsonSerializable()
class ForgotPasswordRequestRequestModel extends Equatable {
  final String email;

  const ForgotPasswordRequestRequestModel({
    required this.email,
  });

  @override
  List<Object?> get props => [
        email,
      ];

  Map<String, dynamic> toJson() =>
      _$ForgotPasswordRequestRequestModelToJson(this);
}
