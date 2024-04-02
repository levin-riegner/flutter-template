import 'package:equatable/equatable.dart';

class CreateAccountModel extends Equatable {
  // TODO: Add fields here 👇
  final String? placeholder;

  const CreateAccountModel({
    this.placeholder,
  });

  @override
  List<Object?> get props => [
        placeholder,
      ];
}
