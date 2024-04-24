import 'package:equatable/equatable.dart';

class UserDeleteRequestModel extends Equatable {
  final String email;

  const UserDeleteRequestModel({
    required this.email,
  });

  @override
  List<Object?> get props => [
        email,
      ];
}
