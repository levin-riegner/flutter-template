import 'package:color_picker/data/study/model/deck.dart';
import 'package:color_picker/data/study/model/flashcard.dart';

/// Local persistence for study flashcards.
///
/// Pure-Dart in-memory store (same convention as [ChatDbService]) so the study
/// feature is testable on the host without native plugins. It is seeded with a
/// single starter deck of real Dart/Flutter flashcards.
class StudyDbService {
  final List<Flashcard> _store = [];
  final Set<String> _deckNames = {};

  StudyDbService() {
    _seedStarterDeck();
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
        back: 'StatefulWidget (via its State object and setState)',
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
  }

  /// Removes the flashcard with [id], if present.
  Future<void> removeFlashcard(String id) async {
    _store.removeWhere((c) => c.id == id);
  }

  /// Removes every flashcard belonging to a deck and stops tracking the deck
  /// name.
  Future<void> removeDeck(String deckName) async {
    _store.removeWhere((c) => c.deckName == deckName);
    _deckNames.remove(deckName);
  }

  /// Replaces the stored card with the same [id], if present.
  Future<void> updateFlashcard(Flashcard flashcard) async {
    final index = _store.indexWhere((c) => c.id == flashcard.id);
    if (index != -1) {
      _store[index] = flashcard;
    }
  }

  Future<void> clear() async {
    _store.clear();
  }
}
