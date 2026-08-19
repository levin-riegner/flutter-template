import 'package:freezed_annotation/freezed_annotation.dart';

part 'focus_error.freezed.dart';

@freezed
sealed class FocusError with _$FocusError {
  const factory FocusError.emptyLabel() = _EmptyLabel;

  const factory FocusError.sessionNotFound({String? reason}) = _SessionNotFound;

  const factory FocusError.unknown({String? reason}) = _Unknown;
}
