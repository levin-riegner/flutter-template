import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_account_request_model.g.dart';

@JsonSerializable()
class CreateAccountRequestModel extends Equatable {
  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? username;

  const CreateAccountRequestModel({
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.username,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        firstName,
        lastName,
        username,
      ];

  Map<String, dynamic> toJson() => _$CreateAccountRequestModelToJson(this);
}
