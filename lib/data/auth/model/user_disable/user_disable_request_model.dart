import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_disable_request_model.g.dart';

@JsonSerializable()
class UserDisableRequestModel extends Equatable {
  final String email;

  const UserDisableRequestModel({
    required this.email,
  });

  @override
  List<Object?> get props => [
        email,
      ];

  Map<String, dynamic> toJson() => _$UserDisableRequestModelToJson(this);
}
