import 'package:swiss_ai/data/local/objectbox/app_objectbox.dart';
import 'package:swiss_ai/data/local/objectbox/objectbox_entities.dart';
import 'package:swiss_ai/objectbox.g.dart';
import 'package:swiss_ai/data/study/model/deck.dart';
import 'package:swiss_ai/data/study/model/flashcard.dart';

/// Local persistence for study flashcards.
///
/// The in-memory store is the source of truth for reads and all business
/// logic; when an [AppObjectBox] is supplied, every mutation is mirrored to
/// ObjectBox and the store is hydrated from ObjectBox on startup, giving
/// durable on-device persistence. Without one (web, tests) it behaves as a
/// pure-Dart in-memory store seeded with a starter deck.
class StudyDbService {
  final AppObjectBox? _ob;
  final List<Flashcard> _store = [];
  final Set<String> _deckNames = {};

  StudyDbService({AppObjectBox? objectBox}) : _ob = objectBox {
    if (_ob != null) {
      _loadFromObjectBox();
      if (_store.isEmpty) {
        _seedStarterDeck();
      }
    } else {
      _seedStarterDeck();
    }
  }

  /// Seeds the store with one starter deck: 'Flutter Basics'.
  void _seedStarterDeck() {
    final now = DateTime.now();
    _deckNames.add('Flutter Basics');
    _store.addAll([
      Flashcard(
        id: 'f1',
        front: 'What language is Flutter written in?',
        back: 'Dart',
        deckName: 'Flutter Basics',
        dueAt: now,
        repetitions: 0,
      ),
      Flashcard(
        id: 'f2',
        front: 'What widget rebuilds when its state changes?',
        back: 'StatefulWidget (via the State object and setState)',
        deckName: 'Flutter Basics',
        dueAt: now,
        repetitions: 0,
      ),
      Flashcard(
        id: 'f3',
        front: 'What does `main()` do in a Flutter app?',
        back: 'It is the entry point that calls runApp with the root widget',
        deckName: 'Flutter Basics',
        dueAt: now,
        repetitions: 0,
      ),
      Flashcard(
        id: 'f4',
        front: 'What tool resolves and fetches Dart package dependencies?',
        back: 'pub (flutter pub / dart pub)',
        deckName: 'Flutter Basics',
        dueAt: now,
        repetitions: 0,
      ),
    ]);
    _persistAll();
  }

  Future<List<Flashcard>> getFlashcards() async {
    return List.unmodifiable(_store);
  }

  Stream<List<Flashcard>> flashcards() async* {
    yield List.unmodifiable(_store);
  }

  /// Groups flashcards into decks with progress counters. Also includes any
  /// empty decks tracked by name so users can see decks they created.
  Future<List<Deck>> getDecks() async {
    final byName = <String, List<Flashcard>>{};
    for (final card in _store) {
      byName.putIfAbsent(card.deckName, () => []).add(card);
    }
    for (final name in _deckNames) {
      byName.putIfAbsent(name, () => []);
    }
    return byName.entries
        .map((entry) => Deck(
              name: entry.key,
              newCount: entry.value.where((c) => c.isNew).length,
              dueCount: entry.value.where((c) => c.isDue).length,
            ))
        .toList();
  }

  Future<void> addDeck(String name) async {
    _deckNames.add(name);
  }

  Future<void> saveFlashcard(Flashcard flashcard) async {
    _store.add(flashcard);
    _put(flashcard);
  }

  Future<void> createFlashcard({
    required String front,
    required String back,
    required String deckName,
  }) async {
    final id = 'fc-${_store.length}-${DateTime.now().microsecondsSinceEpoch}';
    _store.add(Flashcard(
      id: id,
      front: front,
      back: back,
      deckName: deckName,
      dueAt: DateTime.now(),
      repetitions: 0,
    ));
    _put(_store.last);
  }

  /// Removes the flashcard with [id], if present.
  Future<void> removeFlashcard(String id) async {
    final removed = _store.where((c) => c.id == id).toList();
    _store.removeWhere((c) => c.id == id);
    for (final card in removed) {
      _remove(card);
    }
  }

  /// Removes every flashcard belonging to a deck and stops tracking the deck
  /// name.
  Future<void> removeDeck(String deckName) async {
    final removed = _store.where((c) => c.deckName == deckName).toList();
    _store.removeWhere((c) => c.deckName == deckName);
    _deckNames.remove(deckName);
    for (final card in removed) {
      _remove(card);
    }
  }

  /// Replaces the stored card with the same [id], if present.
  Future<void> updateFlashcard(Flashcard flashcard) async {
    final index = _store.indexWhere((c) => c.id == flashcard.id);
    if (index != -1) {
      _store[index] = flashcard;
      _remove(flashcard);
      _put(flashcard);
    }
  }

  Future<void> clear() async {
    _store.clear();
    _deckNames.clear();
    _ob?.flashcards.removeAll();
  }

  // --- ObjectBox mirroring ---

  void _loadFromObjectBox() {
    final ob = _ob!;
    for (final entity in ob.flashcards.query().build().find()) {
      _store.add(_toModel(entity));
      _deckNames.add(entity.deckName);
    }
  }

  void _persistAll() {
    if (_ob == null) return;
    for (final card in _store) {
      _put(card);
    }
  }

  void _put(Flashcard card) {
    final ob = _ob;
    if (ob == null) return;
    final box = ob.flashcards;
    final existing =
        box.query(FlashcardEntity_.uid.equals(card.id)).build().findFirst();
    if (existing != null) {
      existing.uid = card.id;
      existing.front = card.front;
      existing.back = card.back;
      existing.deckName = card.deckName;
      existing.dueAt = card.dueAt;
      existing.repetitions = card.repetitions;
      box.put(existing);
    } else {
      box.put(FlashcardEntity(
        uid: card.id,
        front: card.front,
        back: card.back,
        deckName: card.deckName,
        dueAt: card.dueAt,
        repetitions: card.repetitions,
      ));
    }
  }

  void _remove(Flashcard card) {
    final ob = _ob;
    if (ob == null) return;
    ob.flashcards
        .query(FlashcardEntity_.uid.equals(card.id))
        .build()
        .remove();
  }

  static Flashcard _toModel(FlashcardEntity e) => Flashcard(
        id: e.uid,
        front: e.front,
        back: e.back,
        deckName: e.deckName,
        dueAt: e.dueAt,
        repetitions: e.repetitions,
      );
}
