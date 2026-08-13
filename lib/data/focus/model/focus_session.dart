import 'package:equatable/equatable.dart';

/// A single focus/pomodoro session.
///
/// Pure-Dart immutable model (same convention as [ChatMessage]) so the focus
/// feature stays testable on the host without native plugins.
class FocusSession extends Equatable {
  final String id;
  final String label;

  /// Total session length in seconds.
  final int durationSeconds;

  /// Seconds of focused time elapsed so far.
  final int elapsedSeconds;

  final bool isRunning;

  const FocusSession({
    required this.id,
    required this.label,
    required this.durationSeconds,
    required this.elapsedSeconds,
    required this.isRunning,
  });

  int get remainingSeconds {
    final remaining = durationSeconds - elapsedSeconds;
    return remaining < 0 ? 0 : remaining;
  }

  bool get isComplete => elapsedSeconds >= durationSeconds;

  /// Progress in the range [0.0, 1.0] for a progress bar.
  double get progress {
    if (durationSeconds == 0) {
      return 0.0;
    }
    final p = elapsedSeconds / durationSeconds;
    return p > 1.0 ? 1.0 : p;
  }

  @override
  List<Object?> get props =>
      [id, label, durationSeconds, elapsedSeconds, isRunning];
}
