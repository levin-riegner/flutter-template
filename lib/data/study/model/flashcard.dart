import 'package:equatable/equatable.dart';

/// A single spaced-repetition flashcard.
///
/// Kept as a plain immutable model (same convention as ChatMessage) so the
/// study feature stays testable on the host without native plugins.
///
/// [dueAt] is the timestamp at which the card next becomes reviewable and
/// [repetitions] tracks how many times it has been answered correctly, which
/// together drive the spaced-repetition scheduling in [StudyRepository].
class Flashcard extends Equatable {
  final String id;
  final String front;
  final String back;
  final String deckName;

  /// When this card is next due for review.
  final DateTime dueAt;

  /// Number of consecutive correct answers given so far (0 = new card).
  final int repetitions;

  const Flashcard({
    required this.id,
    required this.front,
    required this.back,
    required this.deckName,
    required this.dueAt,
    required this.repetitions,
  });

  /// Whether the card is due for review right now.
  bool get isDue => !DateTime.now().isBefore(dueAt);

  /// Whether the card has never been reviewed yet.
  bool get isNew => repetitions == 0;

  @override
  List<Object?> get props => [id, front, back, deckName, dueAt, repetitions];
}
