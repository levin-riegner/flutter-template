import 'package:freezed_annotation/freezed_annotation.dart';

part 'corrector_error.freezed.dart';

@freezed
sealed class CorrectorError with _$CorrectorError {
  const factory CorrectorError.emptyInput() = _EmptyInput;

  const factory CorrectorError.unknown({String? reason}) = _Unknown;
}
