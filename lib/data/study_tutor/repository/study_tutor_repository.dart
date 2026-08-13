import 'package:color_picker/data/chat/model/chat_message.dart';
import 'package:color_picker/data/chat/repository/chat_repository.dart';
import 'package:color_picker/data/personas/repository/personas_repository.dart';
import 'package:color_picker/data/study/model/flashcard.dart';
import 'package:color_picker/data/study/repository/study_repository.dart';
import 'package:color_picker/data/study_tutor/model/tutor_session.dart';
import 'package:logging_flutter/logging_flutter.dart';

/// Coordinates an AI tutoring session over a flashcard deck.
///
/// Composes the Study, Personas and Chat repositories: pulls the deck's
/// flashcards, optional active persona system prompt, and hands the deck to
/// the chat model as a tutoring prompt.
class StudyTutorRepository {
  final StudyRepository _studyRepository;
  final PersonalitiesRepository _personasRepository;
  final ChatRepository _chatRepository;

  StudyTutorRepository(
    this._studyRepository,
    this._personasRepository,
    this._chatRepository,
  );

  /// Returns the response payload (prompt + system prompt) used for the last
  /// tutoring interaction, so tests can assert the exact prompt.
  String? _lastSystemPrompt;

  String? get lastSystemPrompt => _lastSystemPrompt;

  /// Builds a tutoring prompt from the deck's flashcards and sends it to the
  /// chat model via the active persona, returning the opening TutorSession.
  Future<TutorSession> startTutorSession(String deckName) async {
    Flogger.i("Starting AI tutor session for deck '$deckName'");
    final cards = await _studyRepository.getDeck(deckName);
    final systemPrompt = await _activePersonaPrompt();
    _lastSystemPrompt = systemPrompt;

    final prompt = _buildPrompt(deckName, cards);
    final messages = await _chatRepository.sendMessage(
      prompt,
      systemPrompt: systemPrompt,
    );
    final welcome = _lastAssistantMessage(messages) ?? 'Let\'s review '
        '${cards.length} cards. Ask me a question or say "quiz me".';

    final personaId = await _personasRepository.getSelectedId();
    return TutorSession(
      deckName: deckName,
      cards: cards,
      welcome: welcome,
      personaId: personaId,
    );
  }

  /// Sends a follow-up learner question within the ongoing tutoring session.
  Future<List<ChatMessage>> ask(String question) async {
    Flogger.i("Asking the AI tutor: $question");
    final systemPrompt = await _activePersonaPrompt();
    return _chatRepository.sendMessage(
      question,
      systemPrompt: systemPrompt,
    );
  }

  Future<String?> _activePersonaPrompt() async {
    final selectedId = await _personasRepository.getSelectedId();
    if (selectedId == null) {
      return null;
    }
    final personas = await _personasRepository.getAll();
    for (final persona in personas) {
      if (persona.id == selectedId) {
        return persona.systemPrompt;
      }
    }
    return null;
  }

  String _buildPrompt(String deckName, List<Flashcard> cards) {
    final cardLines = cards
        .map((c) => '- ${c.front}: ${c.back}')
        .join('\n');
    return 'Act as my tutor for the "$deckName" deck. '
        'Here are the flashcards I am studying:\n$cardLines\n'
        'Warm me up by briefly explaining the first card, then invite me to '
        'continue one card at a time.';
  }

  String? _lastAssistantMessage(List<ChatMessage> messages) {
    for (final message in messages.reversed) {
      if (message.role == ChatRole.assistant) {
        return message.content;
      }
    }
    return null;
  }
}
