import 'package:flutter_test/flutter_test.dart';
import 'package:affirmup/data/models/models.dart';

void main() {
  group('Affirmation', () {
    test('creates with required fields', () {
      final affirmation = Affirmation(
        id: 'test_1',
        text: 'I am worthy',
        category: AffirmationCategory.selfLove,
      );

      expect(affirmation.id, 'test_1');
      expect(affirmation.text, 'I am worthy');
      expect(affirmation.category, AffirmationCategory.selfLove);
      expect(affirmation.isFavorite, false);
    });

    test('creates with isFavorite true', () {
      final affirmation = Affirmation(
        id: 'test_2',
        text: 'I am abundant',
        category: AffirmationCategory.abundance,
        isFavorite: true,
      );

      expect(affirmation.isFavorite, true);
    });

    test('copyWith works', () {
      final affirmation = Affirmation(
        id: 'test_1',
        text: 'I am worthy',
        category: AffirmationCategory.selfLove,
      );

      final updated = affirmation.copyWith(isFavorite: true);
      expect(updated.isFavorite, true);
      expect(updated.id, 'test_1');
      expect(updated.text, 'I am worthy');
    });

    test('toJson and fromJson roundtrip', () {
      final affirmation = Affirmation(
        id: 'test_1',
        text: 'I am worthy',
        category: AffirmationCategory.selfLove,
        isFavorite: true,
      );

      final json = affirmation.toJson();
      final restored = Affirmation.fromJson(json);
      expect(restored, affirmation);
    });

    test('equality works', () {
      final a = Affirmation(
        id: 'test_1',
        text: 'I am worthy',
        category: AffirmationCategory.selfLove,
      );
      final b = Affirmation(
        id: 'test_1',
        text: 'I am worthy',
        category: AffirmationCategory.selfLove,
      );
      expect(a, b);
    });
  });

  group('AffirmationCategory', () {
    test('displayName returns correct values', () {
      expect(AffirmationCategory.selfLove.displayName, 'Self Love');
      expect(AffirmationCategory.abundance.displayName, 'Abundance');
      expect(AffirmationCategory.health.displayName, 'Health');
      expect(AffirmationCategory.relationships.displayName, 'Relationships');
      expect(AffirmationCategory.career.displayName, 'Career');
      expect(AffirmationCategory.confidence.displayName, 'Confidence');
      expect(AffirmationCategory.peace.displayName, 'Peace');
    });

    test('icon returns emoji for each category', () {
      for (final cat in AffirmationCategory.values) {
        expect(cat.icon, isNotEmpty);
      }
    });

    test('colorValue returns valid color for each category', () {
      for (final cat in AffirmationCategory.values) {
        expect(cat.colorValue, greaterThan(0));
      }
    });

    test('has 7 categories', () {
      expect(AffirmationCategory.values.length, 7);
    });
  });

  group('DailyEntry', () {
    test('creates with required fields', () {
      final entry = DailyEntry(
        id: 'entry_1',
        date: DateTime(2025, 3, 29),
        affirmationId: 'aff_1',
      );

      expect(entry.id, 'entry_1');
      expect(entry.completed, false);
      expect(entry.voiceRecorded, false);
      expect(entry.reflection, isNull);
    });

    test('toJson and fromJson roundtrip', () {
      final entry = DailyEntry(
        id: 'entry_1',
        date: DateTime(2025, 3, 29),
        affirmationId: 'aff_1',
        completed: true,
        voiceRecorded: true,
        reflection: 'Felt great today',
      );

      final json = entry.toJson();
      final restored = DailyEntry.fromJson(json);
      expect(restored, entry);
    });
  });

  group('UserStats', () {
    test('creates with defaults', () {
      final stats = UserStats();
      expect(stats.currentStreak, 0);
      expect(stats.longestStreak, 0);
      expect(stats.totalDays, 0);
      expect(stats.favoriteCategory, isNull);
    });

    test('creates with values', () {
      final stats = UserStats(
        currentStreak: 5,
        longestStreak: 10,
        totalDays: 30,
        favoriteCategory: AffirmationCategory.selfLove,
      );
      expect(stats.currentStreak, 5);
      expect(stats.longestStreak, 10);
      expect(stats.totalDays, 30);
      expect(stats.favoriteCategory, AffirmationCategory.selfLove);
    });

    test('toJson and fromJson roundtrip', () {
      final stats = UserStats(
        currentStreak: 5,
        longestStreak: 10,
        totalDays: 30,
      );
      final json = stats.toJson();
      final restored = UserStats.fromJson(json);
      expect(restored, stats);
    });
  });
}
