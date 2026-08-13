import 'package:color_picker/data/study/model/flashcard.dart';
import 'package:color_picker/data/study/service/local/study_db_service.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('StudyDbService', () {
    test('is seeded with one starter deck of 4 cards', () async {
      final dbService = StudyDbService();
      final cards = await dbService.getFlashcards();
      assert(cards.length == 4);
      assert(cards.every((c) => c.deckName == 'Flutter Basics'));
    });

    test('getDecks groups cards into decks with progress counters', () async {
      final dbService = StudyDbService();
      final decks = await dbService.getDecks();
      assert(decks.length == 1);
      assert(decks[0].name == 'Flutter Basics');
      // All four seeded cards are new and due at seed time.
      assert(decks[0].newCount == 4);
      assert(decks[0].dueCount == 4);
    });

    test('saveFlashcard adds a flashcard to the store', () async {
      final dbService = StudyDbService();
      await dbService.saveFlashcard(_card('x1'));
      final cards = await dbService.getFlashcards();
      assert(cards.any((c) => c.id == 'x1'));
    });

    test('updateFlashcard replaces a card with the same id', () async {
      final dbService = StudyDbService();
      await dbService.saveFlashcard(_card('x1'));
      await dbService.updateFlashcard(_card('x1', front: 'Updated'));
      final cards = await dbService.getFlashcards();
      assert(cards.any((c) => c.id == 'x1' && c.front == 'Updated'));
    });

    test('clear empties the store', () async {
      final dbService = StudyDbService();
      await dbService.clear();
      final cards = await dbService.getFlashcards();
      assert(cards.isEmpty);
    });
  });
}

Flashcard _card(String id, {String front = 'front'}) => Flashcard(
      id: id,
      front: front,
      back: 'back',
      deckName: 'Flutter Basics',
      dueAt: DateTime(2026, 1, 1),
      repetitions: 0,
    );
