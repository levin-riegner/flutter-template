import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_delete_request_model.g.dart';

@JsonSerializable()
class UserDeleteRequestModel extends Equatable {
  final String email;

  const UserDeleteRequestModel({
    required this.email,
  });

  @override
  List<Object?> get props => [
        email,
      ];

  Map<String, dynamic> toJson() => _$UserDeleteRequestModelToJson(this);
}
