import 'package:equatable/equatable.dart';

class RefreshTokenRequestModel extends Equatable {
  final String email;
  final String token;

  const RefreshTokenRequestModel({
    required this.email,
    required this.token,
  });

  @override
  List<Object?> get props => [
        email,
        token,
      ];
}
