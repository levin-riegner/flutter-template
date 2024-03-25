import 'package:equatable/equatable.dart';

class UserUpdateRequestModel extends Equatable {
  final String? email;
  final String? firstName;
  final String? lastName;

  const UserUpdateRequestModel({
    this.email,
    this.firstName,
    this.lastName,
  });

  @override
  List<Object?> get props => [
        email,
        firstName,
        lastName,
      ];
}
