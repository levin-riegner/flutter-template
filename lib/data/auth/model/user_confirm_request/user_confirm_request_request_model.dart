import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_confirm_request_request_model.g.dart';

@JsonSerializable()
class UserConfirmRequestRequestModel extends Equatable {
  final String email;

  const UserConfirmRequestRequestModel({
    required this.email,
  });

  @override
  List<Object?> get props => [
        email,
      ];

  Map<String, dynamic> toJson() => _$UserConfirmRequestRequestModelToJson(this);
}
