import 'dart:convert';

import 'package:swiss_ai/data/quiz/model/quiz_item.dart';

/// Pure-Dart quiz prompt builder and JSON parser.
///
/// No I/O — the LLM call itself lives in [QuizRepository]; this service owns
/// the prompt format and the (tolerant) parsing of the model's JSON reply,
/// which keeps both fully unit-testable.
class QuizGenerationService {
  /// System prompt: strict JSON discipline, document-grounded questions.
  static const String systemPrompt =
      'You convert documents into flashcards for spaced repetition. '
      'Always reply with ONLY a JSON array. Each item is an object with '
      'exactly two string fields: "front" (a question) and "back" '
      '(the short expected answer). Questions must be answerable strictly '
      'from the provided document — never invent facts. No prose, no '
      'markdown, no code fences.';

  /// Builds the user prompt for generating [count] quiz items from
  /// [document].
  String buildPrompt(String document, int count) {
    return 'Generate $count flashcards from the document below.\n\n'
        '=== DOCUMENT ===\n'
        '$document\n'
        '=== END DOCUMENT ===\n\n'
        'Reply with a JSON array of $count objects: '
        '{"front": "question", "back": "answer"}.';
  }

  /// Parses the model's reply into [QuizItem]s.
  ///
  /// Tolerant of leading whitespace, markdown code fences, and stray prose
  /// before/after the JSON array (the model is told to avoid these, but
  /// small LLMs occasionally drift). Throws a [FormatException] when no
  /// valid JSON array of {front, back} objects can be recovered.
  List<QuizItem> parseItems(String raw) {
    var text = raw.trim();

    // Drop markdown fences if present.
    final fenceStart = text.indexOf('```');
    if (fenceStart != -1) {
      final after = text.substring(fenceStart + 3);
      final close = after.indexOf('```');
      text = (close != -1 ? after.substring(0, close) : after).trim();
    }

    // Isolate the outermost JSON array.
    final start = text.indexOf('[');
    final end = text.lastIndexOf(']');
    if (start == -1 || end == -1 || end < start) {
      throw FormatException(
          'Model reply did not contain a JSON array');
    }
    final json = text.substring(start, end + 1);

    dynamic decoded;
    try {
      decoded = jsonDecode(json);
    } catch (_) {
      // Repair common small-model drift: trailing commas.
      final repaired =
          json.replaceAll(RegExp(r',\s*}'), ']').replaceAll(RegExp(r',\s*\]'), ']');
      decoded = jsonDecode(repaired);
    }

    if (decoded is! List) {
      throw FormatException('Model JSON was not an array');
    }

    final items = <QuizItem>[];
    for (final entry in decoded) {
      if (entry is! Map) continue;
      final front = entry['front'];
      final back = entry['back'];
      if (front is String && back is String) {
        final f = front.trim();
        final b = back.trim();
        if (f.isNotEmpty && b.isNotEmpty) {
          items.add(QuizItem(front: f, back: b));
        }
      }
    }
    return items;
  }
}
