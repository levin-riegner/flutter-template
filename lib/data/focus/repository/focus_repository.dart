import 'package:swiss_ai/data/focus/model/focus_session.dart';
import 'package:swiss_ai/data/focus/service/local/focus_db_service.dart';
import 'package:logging_flutter/logging_flutter.dart';

/// Default focus session lengths (Pomodoro-ish).
class FocusDurations {
  static const int shortBreakSeconds = 300;

  static const int longFocusSeconds = 1500;

  static const int defaultFocusSeconds = 1500;
}

/// Coordinates focus sessions: start/stop/reset and ticking elapsed time.
///
/// Takes an injected clock so the timer logic is testable on the host without
/// waiting for real wall-clock time.
class FocusRepository {
  final FocusDbService _dbService;
  final DateTime Function() _clock;
  DateTime? _lastTick;

  /// Id of the session currently advancing, if any.
  String? _activeId;

  FocusRepository(
    this._dbService, {
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  Future<List<FocusSession>> getSessions() async {
    return _dbService.getSessions();
  }

  /// Returns the session with [id], or null when absent.
  FocusSession? _byId(List<FocusSession> sessions, String id) {
    for (final s in sessions) {
      if (s.id == id) {
        return s;
      }
    }
    return null;
  }

  /// Creates a new paused session and returns it.
  Future<FocusSession> createSession(
    String label, {
    int durationSeconds = FocusDurations.defaultFocusSeconds,
  }) async {
    final id = await _dbService.createSession(label, durationSeconds);
    Flogger.i("Created focus session '$label' ($durationSeconds s)");
    final sessions = await _dbService.getSessions();
    return sessions.firstWhere((s) => s.id == id);
  }

  /// Starts advancing the given session. Any previously running session is
  /// paused implicitly.
  Future<void> startSession(String id) async {
    await _pauseActive();
    await _dbService.setRunning(id, true);
    _activeId = id;
    _lastTick = _clock();
  }

  /// Pauses the running session, if any.
  Future<void> pause() async {
    await tick();
    await _pauseActive();
  }

  /// Advances all running sessions by the wall-clock delta since [startSession]
  /// or the last [tick]. Returns the currently running session, or null.
  Future<FocusSession?> tick() async {
    final activeId = _activeId;
    if (activeId == null) {
      return null;
    }
    final now = _clock();
    final elapsed = _lastTick == null
        ? 0
        : now.difference(_lastTick!).inSeconds;
    _lastTick = now;
    if (elapsed <= 0) {
      final sessions = await _dbService.getSessions();
      return _byId(sessions, activeId);
    }
    final sessions = await _dbService.getSessions();
    final session = _byId(sessions, activeId);
    if (session == null) {
      return null;
    }
    final newElapsed = session.elapsedSeconds + elapsed;
    await _dbService.updateElapsed(activeId, newElapsed < 0 ? 0 : newElapsed);
    await _completeIfFinished(activeId, newElapsed);
    final updated = await _dbService.getSessions();
    return _byId(updated, activeId);
  }

  Future<void> _pauseActive() async {
    final activeId = _activeId;
    if (activeId == null) {
      return;
    }
    await _dbService.setRunning(activeId, false);
    _activeId = null;
    _lastTick = null;
  }

  Future<void> _completeIfFinished(String id, int elapsedSeconds) async {
    final sessions = await _dbService.getSessions();
    final session = _byId(sessions, id);
    if (session == null || elapsedSeconds < session.durationSeconds) {
      return;
    }
    Flogger.i("Focus session '$id' completed");
    // Keep the session stored (complete) so the UI can show a finished state.
  }
}
