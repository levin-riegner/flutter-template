import 'package:freezed_annotation/freezed_annotation.dart';

part 'personas_error.freezed.dart';

@freezed
sealed class PersonalitiesError with _$PersonalitiesError {
  const factory PersonalitiesError.empty() = _Empty;

  const factory PersonalitiesError.unknown({String? reason}) = _Unknown;
}
