import 'package:swiss_ai/data/study/repository/study_repository.dart';
import 'package:swiss_ai/data/study/service/local/study_db_service.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('StudyRepository', () {
    // Fixed clock so spacing assertions are deterministic.
    final clock = DateTime(2026, 1, 1, 12, 0);
    late StudyDbService dbService;
    late StudyRepository repository;

    setUp(() {
      dbService = StudyDbService();
      repository = StudyRepository(dbService, now: () => clock);
    });

    test('getDecks returns the seeded deck with progress counters', () async {
      final decks = await repository.getDecks();
      assert(decks.length == 1);
      assert(decks[0].name == 'Flutter Basics');
      assert(decks[0].newCount == 4);
      assert(decks[0].dueCount == 4);
    });

    test('getDeck filters flashcards by deck name', () async {
      final cards = await repository.getDeck('Flutter Basics');
      assert(cards.length == 4);
      assert(cards.every((c) => c.deckName == 'Flutter Basics'));
    });

    test('correct answer sets due later and grows the interval', () async {
      final first = await repository.answerCard(id: 'f1', correct: true);
      assert(first.repetitions == 1);
      assert(first.dueAt == clock.add(StudyScheduler.intervalFor(1)));

      final second = await repository.answerCard(id: 'f1', correct: true);
      assert(second.repetitions == 2);
      assert(second.dueAt == clock.add(StudyScheduler.intervalFor(2)));
      // Each correct answer pushes the due date further out.
      assert(second.dueAt.isAfter(first.dueAt));
    });

    test('wrong answer sets due sooner than a correct answer', () async {
      final correct = await repository.answerCard(id: 'f1', correct: true);
      final wrong = await repository.answerCard(id: 'f2', correct: false);
      // A wrong answer resets review progress.
      assert(wrong.repetitions == 0);
      // Wrong answers come back much sooner than correct ones.
      assert(wrong.dueAt.isBefore(correct.dueAt));
    });

    test('answerCard throws for an unknown card id', () async {
      var threw = false;
      try {
        await repository.answerCard(id: 'nope', correct: true);
      } on StateError {
        threw = true;
      }
      assert(threw);
    });
  });
}
