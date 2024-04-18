import 'package:equatable/equatable.dart';

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
