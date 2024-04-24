import 'package:equatable/equatable.dart';

class UserDisableModel extends Equatable {
  final int? status;

  const UserDisableModel({
    this.status,
  });

  @override
  List<Object?> get props => [
        status,
      ];
}
