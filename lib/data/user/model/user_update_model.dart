import 'package:equatable/equatable.dart';

class UserUpdateModel extends Equatable {
  final int? status;

  const UserUpdateModel({
    this.status,
  });

  @override
  List<Object?> get props => [
        status,
      ];
}
