import 'package:equatable/equatable.dart';

class UserConfirmRequestRequestModel extends Equatable {
  final String email;

  const UserConfirmRequestRequestModel({
    required this.email,
  });

  @override
  List<Object?> get props => [
        email,
      ];

  Map<String, dynamic> toJson() => {
        'email': email,
      };
}
