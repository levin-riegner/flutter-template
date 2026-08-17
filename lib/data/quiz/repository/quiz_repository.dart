import 'package:swiss_ai/data/chat/model/chat_message.dart';
import 'package:swiss_ai/data/chat/repository/chat_repository.dart';
import 'package:swiss_ai/data/quiz/model/quiz_item.dart';
import 'package:swiss_ai/data/quiz/service/local/quiz_generation_service.dart';
import 'package:swiss_ai/data/study/repository/study_repository.dart';
import 'package:logging_flutter/logging_flutter.dart';

/// Generates a quiz from a document and can save it as a study deck.
///
/// Uses the on-device chat model (via [ChatRepository]) with strict-JSON
/// prompts, and [StudyRepository] to persist generated items as a new deck
/// so they flow into spaced repetition.
class QuizRepository {
  final ChatRepository _chatRepository;
  final StudyRepository _studyRepository;
  final QuizGenerationService _service;

  QuizRepository(
    this._chatRepository,
    this._studyRepository, {
    QuizGenerationService? service,
  }) : _service = service ?? QuizGenerationService();

  /// Generates up to [count] quiz items grounded in [document].
  Future<List<QuizItem>> generateFromDocument(
    String document, {
    int count = 5,
  }) async {
    final trimmed = document.trim();
    if (trimmed.isEmpty) {
      throw FormatException('Document is empty');
    }
    Flogger.i(
        'Generating $count quiz items from ${trimmed.length} chars of document');

    final prompt = _service.buildPrompt(trimmed, count);
    final messages = await _chatRepository.sendMessage(
      prompt,
      systemPrompt: QuizGenerationService.systemPrompt,
      disableThinking: true,
    );

    String? raw;
    for (final message in messages.reversed) {
      if (message.role == ChatRole.assistant) {
        raw = message.content;
        break;
      }
    }
    if (raw == null) {
      throw StateError('Model returned no assistant message');
    }

    final items = _service.parseItems(raw);
    if (items.isEmpty) {
      throw StateError('Model produced no usable quiz items');
    }
    return items.length <= count ? items : items.take(count).toList();
  }

  /// Saves [items] as a new study deck named [deckName].
  Future<int> saveAsDeck(List<QuizItem> items, String deckName) async {
    if (items.isEmpty) {
      throw FormatException('No quiz items to save');
    }
    Flogger.i("Saving ${items.length} quiz items as deck '$deckName'");
    await _studyRepository.createDeck(deckName);
    for (final item in items) {
      await _studyRepository.addCard(
        deckName: deckName,
        front: item.front,
        back: item.back,
      );
    }
    return items.length;
  }
}
