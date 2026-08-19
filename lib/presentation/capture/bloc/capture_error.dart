import 'package:freezed_annotation/freezed_annotation.dart';

part 'capture_error.freezed.dart';

@freezed
sealed class CaptureError with _$CaptureError {
  const factory CaptureError.noPermission() = NoPermission;

  const factory CaptureError.fileNotFound() = FileNotFound;

  const factory CaptureError.visionUnavailable({
    required String reason,
  }) = VisionUnavailable;

  const factory CaptureError.unknown({required String reason}) = Unknown;
}
