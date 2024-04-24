import 'package:equatable/equatable.dart';

// TODO: Move request models to models folder and use jsonserializable
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

  Map<String, dynamic> toJson() => {
        'email': email,
        'code': code,
      };
}
