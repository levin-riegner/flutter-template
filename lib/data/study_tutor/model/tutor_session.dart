import 'package:color_picker/data/chat/model/chat_message.dart';
import 'package:color_picker/data/study/model/flashcard.dart';
import 'package:equatable/equatable.dart';

/// The result of starting an AI tutoring session over a flashcard deck.
///
/// Pure-Dart immutable model (same convention as [ChatMessage]) so the tutor
/// feature is testable on the host without native plugins.
class TutorSession extends Equatable {
  final String deckName;

  /// The cards the tutor is teaching.
  final List<Flashcard> cards;

  /// The assistant's opening tutoring message.
  final String welcome;

  /// Id of the persona whose system prompt scoped this session (may be null).
  final String? personaId;

  const TutorSession({
    required this.deckName,
    required this.cards,
    required this.welcome,
    this.personaId,
  });

  @override
  List<Object?> get props => [deckName, cards, welcome, personaId];
}
