import 'package:equatable/equatable.dart';

class UserDeleteModel extends Equatable {
  final int? status;

  const UserDeleteModel({
    this.status,
  });

  @override
  List<Object?> get props => [
        status,
      ];
}
