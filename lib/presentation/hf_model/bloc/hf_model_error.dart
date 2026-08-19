import 'package:freezed_annotation/freezed_annotation.dart';

part 'hf_model_error.freezed.dart';

@freezed
sealed class HfModelError with _$HfModelError {
  const factory HfModelError.empty() = _Empty;

  const factory HfModelError.unknown({String? reason}) = _Unknown;
}
