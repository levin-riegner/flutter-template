import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:affirmup/data/services/services.dart';

void main() {
  late StorageService storage;
  late ReviewPromptService service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storage = StorageService(prefs);
    service = ReviewPromptService(storage);
  });

  group('ReviewPromptService', () {
    test('session count starts at 0', () {
      expect(service.getSessionCount(), 0);
    });

    test('incrementSession increases count', () async {
      await service.incrementSession();
      expect(service.getSessionCount(), 1);
      await service.incrementSession();
      expect(service.getSessionCount(), 2);
    });

    test('shouldPrompt false before 5 sessions', () async {
      for (int i = 0; i < 4; i++) {
        await service.incrementSession();
      }
      expect(service.shouldPrompt(), false);
    });

    test('shouldPrompt true at 5 sessions with no prior prompt', () async {
      for (int i = 0; i < 5; i++) {
        await service.incrementSession();
      }
      expect(service.shouldPrompt(), true);
    });

    test('shouldPrompt false after marking prompted', () async {
      for (int i = 0; i < 5; i++) {
        await service.incrementSession();
      }
      await service.markPrompted();
      expect(service.shouldPrompt(), false);
    });

    test('trigger session count is 5', () {
      expect(ReviewPromptService.triggerSessionCount, 5);
    });

    test('cooldown is 60 days', () {
      expect(ReviewPromptService.cooldownDays, 60);
    });

    test('lastPromptDate is null initially', () {
      expect(service.getLastPromptDate(), isNull);
    });

    test('setLastPromptDate stores date', () async {
      final date = DateTime(2025, 3, 29);
      await service.setLastPromptDate(date);
      final stored = service.getLastPromptDate();
      expect(stored, isNotNull);
      expect(stored!.year, 2025);
      expect(stored.month, 3);
      expect(stored.day, 29);
    });
  });
}
