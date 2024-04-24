import 'package:equatable/equatable.dart';

class ForgotPasswordRequestRequestModel extends Equatable {
  final String email;

  const ForgotPasswordRequestRequestModel({
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
