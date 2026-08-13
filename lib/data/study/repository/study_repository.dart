import 'package:color_picker/data/study/model/deck.dart';
import 'package:color_picker/data/study/model/flashcard.dart';
import 'package:color_picker/data/study/service/local/study_db_service.dart';
import 'package:logging_flutter/logging_flutter.dart';

/// Spaced-repetition scheduling parameters for study cards.
abstract class StudyScheduler {
  /// Base review interval after a single correct answer.
  static const Duration baseInterval = Duration(minutes: 1);

  /// Short interval applied after a wrong answer so the card returns sooner.
  static const Duration wrongInterval = Duration(seconds: 30);

  /// The review interval for a card with [repetitions] consecutive correct
  /// answers, growing exponentially as the card is mastered.
  static Duration intervalFor(int repetitions) =>
      baseInterval * (1 << repetitions);
}

class StudyRepository {
  final StudyDbService _dbService;

  /// Injectable clock so tests can control the "now" used for scheduling.
  final DateTime Function() _now;

  StudyRepository(this._dbService, {DateTime Function()? now})
      : _now = now ?? DateTime.now;

  Future<List<Deck>> getDecks() => _dbService.getDecks();

  /// Returns the flashcards belonging to [deckName].
  Future<List<Flashcard>> getDeck(String deckName) async {
    final cards = await _dbService.getFlashcards();
    return List.unmodifiable(
      cards.where((c) => c.deckName == deckName).toList(),
    );
  }

  /// Answers the card with [id] and reschedules it for spaced repetition.
  ///
  /// A correct answer increments the repetition count and pushes the due date
  /// further out (longer interval). A wrong answer resets progress and
  /// schedules the card back much sooner.
  Future<Flashcard> answerCard({
    required String id,
    required bool correct,
  }) async {
    Flogger.i("Answering flashcard $id (correct=$correct)");
    final cards = await _dbService.getFlashcards();
    Flashcard? card;
    for (final candidate in cards) {
      if (candidate.id == id) {
        card = candidate;
        break;
      }
    }
    if (card == null) {
      throw StateError('No flashcard with id $id');
    }

    final now = _now();
    final Flashcard updated;
    if (correct) {
      final nextRepetitions = card.repetitions + 1;
      updated = Flashcard(
        id: card.id,
        front: card.front,
        back: card.back,
        deckName: card.deckName,
        dueAt: now.add(StudyScheduler.intervalFor(nextRepetitions)),
        repetitions: nextRepetitions,
      );
    } else {
      updated = Flashcard(
        id: card.id,
        front: card.front,
        back: card.back,
        deckName: card.deckName,
        dueAt: now.add(StudyScheduler.wrongInterval),
        repetitions: 0,
      );
    }
    await _dbService.updateFlashcard(updated);
    return updated;
  }
}
