import 'package:swiss_ai/data/focus/model/focus_session.dart';
import 'package:swiss_ai/data/local/objectbox/app_objectbox.dart';
import 'package:swiss_ai/data/local/objectbox/objectbox_entities.dart';
import 'package:swiss_ai/objectbox.g.dart';

/// Local persistence for focus sessions.
///
/// The in-memory store is the source of truth; when an [AppObjectBox] is
/// supplied, sessions are mirrored to ObjectBox and hydrated on startup so a
/// running timer survives an app restart. Without one (web, tests) it is a
/// pure-Dart store.
class FocusDbService {
  final AppObjectBox? _ob;
  final List<FocusSession> _store = [];
  int _idCounter = 0;

  FocusDbService({AppObjectBox? objectBox}) : _ob = objectBox {
    final ob = _ob;
    if (ob != null) {
      for (final entity in ob.focus.query().build().find()) {
        _store.add(_toModel(entity));
      }
    }
  }

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
    _put(_store.last);
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
    _put(_store[index]);
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
    _put(_store[index]);
  }

  Future<void> clear() async {
    _store.clear();
    _ob?.focus.removeAll();
  }

  // --- ObjectBox mirroring ---

  void _put(FocusSession s) {
    final ob = _ob;
    if (ob == null) return;
    final box = ob.focus;
    final existing =
        box.query(FocusSessionEntity_.uid.equals(s.id)).build().findFirst();
    if (existing != null) {
      existing.label = s.label;
      existing.durationSeconds = s.durationSeconds;
      existing.elapsedSeconds = s.elapsedSeconds;
      existing.isRunning = s.isRunning;
      box.put(existing);
    } else {
      box.put(FocusSessionEntity(
        uid: s.id,
        label: s.label,
        durationSeconds: s.durationSeconds,
        elapsedSeconds: s.elapsedSeconds,
        isRunning: s.isRunning,
      ));
    }
  }

  static FocusSession _toModel(FocusSessionEntity e) => FocusSession(
        id: e.uid,
        label: e.label,
        durationSeconds: e.durationSeconds,
        elapsedSeconds: e.elapsedSeconds,
        isRunning: e.isRunning,
      );
}
