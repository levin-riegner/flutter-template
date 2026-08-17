import 'package:swiss_ai/data/study/repository/study_repository.dart';
import 'package:swiss_ai/data/study/service/local/study_db_service.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('StudyRepository deck management', () {
    final clock = DateTime(2026, 1, 1, 12, 0);
    late StudyDbService dbService;
    late StudyRepository repository;

    setUp(() {
      dbService = StudyDbService();
      repository = StudyRepository(dbService, now: () => clock);
    });

    test('createDeck adds a new empty deck to the deck list', () async {
      final created = await repository.createDeck('Spanish Vocab');
      assert(created.name == 'Spanish Vocab');
      assert(created.newCount == 0);
      assert(created.dueCount == 0);
      final decks = await repository.getDecks();
      assert(decks.any((d) => d.name == 'Spanish Vocab'));
    });

    test('addCard adds a card visible in the deck', () async {
      await repository.createDeck('Spanish Vocab');
      final card = await repository.addCard(
        deckName: 'Spanish Vocab',
        front: 'hola',
        back: 'hello',
      );
      assert(card.front == 'hola');
      final cards = await repository.getDeck('Spanish Vocab');
      assert(cards.any((c) => c.front == 'hola'));
    });

    test('deleteDeck removes the deck and its cards', () async {
      await repository.createDeck('Spanish Vocab');
      await repository.addCard(
        deckName: 'Spanish Vocab',
        front: 'hola',
        back: 'hello',
      );
      await repository.deleteDeck('Spanish Vocab');
      final decks = await repository.getDecks();
      assert(!decks.any((d) => d.name == 'Spanish Vocab'));
      final cards = await repository.getDeck('Spanish Vocab');
      assert(cards.isEmpty);
    });

    test('removeCard removes a single card', () async {
      final card = await repository.addCard(
        deckName: 'Flutter Basics',
        front: 'temporary',
        back: 'card',
      );
      await repository.removeCard(card.id);
      final cards = await repository.getDeck('Flutter Basics');
      assert(!cards.any((c) => c.id == card.id));
    });
  });
}
