import 'package:flutter/foundation.dart';
import 'package:swiss_ai/data/local/objectbox/objectbox_entities.dart';
import 'package:swiss_ai/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

/// Owns the ObjectBox [Store] for the app's on-device data layer.
///
/// Created once in [Dependencies] and injected into the `*DbService`s.
/// On web (no native library) the store is not created; services then fall
/// back to their in-memory stores.
class AppObjectBox {
  AppObjectBox._(this._store);

  final Store _store;

  static AppObjectBox? _instance;

  /// The shared instance, or null when ObjectBox is unavailable (web).
  static AppObjectBox? get instance => _instance;

  Box<FlashcardEntity> get flashcards => _store.box<FlashcardEntity>();
  Box<ChatMessageEntity> get messages => _store.box<ChatMessageEntity>();
  Box<SelectionEntity> get selections => _store.box<SelectionEntity>();
  Box<FocusSessionEntity> get focus => _store.box<FocusSessionEntity>();

  /// The currently selected persona id, or null.
  String? get selectedPersona {
    final row = selections
        .query(SelectionEntity_.row.equals('selectedPersona'))
        .build()
        .findFirst();
    return row?.value;
  }

  /// Persists the selected persona id (null clears the selection).
  void setSelectedPersona(String? id) {
    final box = selections;
    box
        .query(SelectionEntity_.row.equals('selectedPersona'))
        .build()
        .remove();
    if (id != null) {
      box.put(SelectionEntity(row: 'selectedPersona', value: id));
    }
  }

  /// Opens the store at [directory] (application directory).
  ///
  /// Returns null on web, where the ObjectBox native library is unavailable.
  static Future<AppObjectBox?> create({
    required String directory,
  }) async {
    if (kIsWeb || _instance != null) {
      return _instance;
    }
    final store = await openStore(directory: directory);
    _instance = AppObjectBox._(store);
    return _instance;
  }

  /// Clears all rows — used by tests so each run starts from a known state.
  void clearAll() {
    _store.box<FlashcardEntity>().removeAll();
    _store.box<ChatMessageEntity>().removeAll();
    _store.box<SelectionEntity>().removeAll();
    _store.box<FocusSessionEntity>().removeAll();
  }

  Future<void> close() async {
    _store.close();
    _instance = null;
  }
}
