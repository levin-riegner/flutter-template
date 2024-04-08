import 'package:equatable/equatable.dart';

class UserConfirmModel extends Equatable {
  final int? status;

  const UserConfirmModel({
    this.status,
  });

  @override
  List<Object?> get props => [
        status,
      ];
}
