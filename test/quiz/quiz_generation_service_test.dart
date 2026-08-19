import 'package:flutter_test/flutter_test.dart';
import 'package:swiss_ai/data/quiz/service/local/quiz_generation_service.dart';

void main() {
  final service = QuizGenerationService();

  group('parseItems', () {
    test('parses a clean JSON array', () {
      const raw = '[{"front":"Q1","back":"A1"},{"front":"Q2","back":"A2"}]';
      final items = service.parseItems(raw);
      expect(items, hasLength(2));
      expect(items[0].front, 'Q1');
      expect(items[0].back, 'A1');
      expect(items[1].front, 'Q2');
    });

    test('tolerates leading whitespace and prose', () {
      const raw =
          '\n\nHere are the flashcards:\n[{"front":"Q","back":"A"}]\nDone.';
      final items = service.parseItems(raw);
      expect(items, hasLength(1));
      expect(items.single.front, 'Q');
    });

    test('tolerates markdown fences', () {
      const raw = '```json\n[{"front":"Q","back":"A"}]\n```';
      final items = service.parseItems(raw);
      expect(items.single.back, 'A');
    });

    test('repairs trailing commas', () {
      const raw = '[{"front":"Q","back":"A"},]';
      final items = service.parseItems(raw);
      expect(items.single.front, 'Q');
    });

    test('skips malformed entries', () {
      const raw =
          '[{"front":"good","back":"good"},{"front":42},{"back":"missing"}]';
      final items = service.parseItems(raw);
      expect(items, hasLength(1));
    });

    test('throws when no JSON array present', () {
      expect(() => service.parseItems('no json here'),
          throwsA(isA<FormatException>()));
    });
  });

  group('buildPrompt', () {
    test('embeds document and count', () {
      final prompt = service.buildPrompt('DOC', 4);
      expect(prompt, contains('DOC'));
      expect(prompt, contains('4'));
      expect(prompt, contains('=== DOCUMENT ==='));
    });
  });
}
