import 'package:equatable/equatable.dart';

class CreateAccountModel extends Equatable {
  final int? status;
  final String? userId;

  const CreateAccountModel({
    this.status,
    this.userId,
  });

  @override
  List<Object?> get props => [
        status,
        userId,
      ];
}
