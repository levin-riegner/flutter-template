import 'package:equatable/equatable.dart';

class UserDisableRequestModel extends Equatable {
  final String email;

  const UserDisableRequestModel({
    required this.email,
  });

  @override
  List<Object?> get props => [
        email,
      ];
}
