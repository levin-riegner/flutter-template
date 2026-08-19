import 'package:freezed_annotation/freezed_annotation.dart';

part 'recording_error.freezed.dart';

@freezed
sealed class RecordingError with _$RecordingError {
  const factory RecordingError.emptyResponse() = _EmptyResponse;
  const factory RecordingError.unknown({String? reason}) = _Unknown;
}
