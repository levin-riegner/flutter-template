import 'package:swiss_ai/data/focus/model/focus_session.dart';

/// Local persistence for focus sessions.
///
/// Pure-Dart in-memory store (same convention as [ChatDbService]) so the focus
/// feature is testable on the host without native plugins.
class FocusDbService {
  final List<FocusSession> _store = [];
  int _idCounter = 0;

  Future<List<FocusSession>> getSessions() async {
    return List.unmodifiable(_store);
  }

  Future<String> createSession(
    String label,
    int durationSeconds,
  ) async {
    final id = '${_idCounter++}';
    _store.add(FocusSession(
      id: id,
      label: label,
      durationSeconds: durationSeconds,
      elapsedSeconds: 0,
      isRunning: false,
    ));
    return id;
  }

  Future<void> updateElapsed(String id, int elapsedSeconds) async {
    final index = _store.indexWhere((s) => s.id == id);
    if (index == -1) {
      return;
    }
    final existing = _store[index];
    _store[index] = FocusSession(
      id: existing.id,
      label: existing.label,
      durationSeconds: existing.durationSeconds,
      elapsedSeconds: elapsedSeconds,
      isRunning: existing.isRunning,
    );
  }

  Future<void> setRunning(String id, bool isRunning) async {
    final index = _store.indexWhere((s) => s.id == id);
    if (index == -1) {
      return;
    }
    final existing = _store[index];
    _store[index] = FocusSession(
      id: existing.id,
      label: existing.label,
      durationSeconds: existing.durationSeconds,
      elapsedSeconds: existing.elapsedSeconds,
      isRunning: isRunning,
    );
  }

  Future<void> clear() async {
    _store.clear();
  }
}
