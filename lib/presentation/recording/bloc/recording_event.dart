import 'package:freezed_annotation/freezed_annotation.dart';

part 'recording_event.freezed.dart';

@freezed
sealed class RecordingEvent with _$RecordingEvent {
  const factory RecordingEvent.capture({required String title}) =
      RecordingEventCapture;

  const factory RecordingEvent.clear() = RecordingEventClear;
}
