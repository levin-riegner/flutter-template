import 'package:freezed_annotation/freezed_annotation.dart';

part 'deck_manager_error.freezed.dart';

@freezed
sealed class DeckManagerError with _$DeckManagerError {
  const factory DeckManagerError.emptyName({String? reason}) = _EmptyName;

  const factory DeckManagerError.duplicate({String? reason}) = _Duplicate;

  const factory DeckManagerError.unknown({String? reason}) = _Unknown;
}
