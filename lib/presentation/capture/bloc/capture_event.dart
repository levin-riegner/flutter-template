import 'package:freezed_annotation/freezed_annotation.dart';

part 'capture_event.freezed.dart';

@freezed
sealed class CaptureEvent with _$CaptureEvent {
  const factory CaptureEvent.pick({required String path}) = CapturePick;

  const factory CaptureEvent.retry() = CaptureRetry;

  const factory CaptureEvent.reset() = CaptureReset;
}
