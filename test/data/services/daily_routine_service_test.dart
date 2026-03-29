import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:affirmup/data/models/models.dart';
import 'package:affirmup/data/services/services.dart';

void main() {
  late StorageService storage;
  late DailyRoutineService service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storage = StorageService(prefs);
    service = DailyRoutineService(storage);
  });

  group('DailyRoutineService', () {
    test('morning starts not completed', () {
      expect(service.isMorningCompleted(), false);
    });

    test('evening starts not completed', () {
      expect(service.isEveningCompleted(), false);
    });

    test('completeMorning marks morning done', () async {
      await service.completeMorning();
      expect(service.isMorningCompleted(), true);
    });

    test('completeEvening marks evening done', () async {
      await service.completeEvening();
      expect(service.isEveningCompleted(), true);
    });

    test('stats start at zero', () {
      final stats = service.getStats();
      expect(stats.currentStreak, 0);
      expect(stats.longestStreak, 0);
      expect(stats.totalDays, 0);
    });

    test('completing updates streak', () async {
      await service.completeMorning();
      final stats = service.getStats();
      expect(stats.currentStreak, 1);
      expect(stats.longestStreak, 1);
      expect(stats.totalDays, 1);
    });

    test('getEntries starts empty', () {
      expect(service.getEntries(), isEmpty);
    });

    test('addEntry adds and retrieves entry', () async {
      final entry = DailyEntry(
        id: 'e1',
        date: DateTime.now(),
        affirmationId: 'a1',
        completed: true,
      );
      await service.addEntry(entry);
      final entries = service.getEntries();
      expect(entries.length, 1);
      expect(entries.first.completed, true);
    });

    test('getCompletionMap returns correct map', () async {
      final entry = DailyEntry(
        id: 'e1',
        date: DateTime(2025, 3, 29),
        affirmationId: 'a1',
        completed: true,
      );
      await service.addEntry(entry);
      final map = service.getCompletionMap();
      expect(map['2025-03-29'], true);
    });
  });
}
