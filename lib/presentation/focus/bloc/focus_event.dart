import 'package:freezed_annotation/freezed_annotation.dart';

part 'focus_event.freezed.dart';

@freezed
sealed class FocusEvent with _$FocusEvent {
  const factory FocusEvent.loadSessions() = FocusEventLoadSessions;

  const factory FocusEvent.createSession({
    required String label,
    required int durationSeconds,
  }) = FocusEventCreateSession;

  const factory FocusEvent.start({required String sessionId}) =
      FocusEventStart;

  const factory FocusEvent.pause() = FocusEventPause;

  const factory FocusEvent.tick() = FocusEventTick;

  const factory FocusEvent.clear() = FocusEventClear;
}
