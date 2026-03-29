import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:affirmup/data/models/models.dart';
import 'package:affirmup/data/services/services.dart';

void main() {
  late StorageService storage;
  late AffirmationService service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storage = StorageService(prefs);
    service = AffirmationService(storage);
  });

  group('AffirmationService', () {
    test('has 210+ affirmations', () {
      expect(service.allAffirmations.length, greaterThanOrEqualTo(210));
    });

    test('has ~30 affirmations per category', () {
      for (final cat in AffirmationCategory.values) {
        final count = service.getCategoryCount(cat);
        expect(count, greaterThanOrEqualTo(28));
        expect(count, lessThanOrEqualTo(32));
      }
    });

    test('getByCategory returns correct affirmations', () {
      final selfLove = service.getByCategory(AffirmationCategory.selfLove);
      expect(selfLove, isNotEmpty);
      for (final a in selfLove) {
        expect(a.category, AffirmationCategory.selfLove);
      }
    });

    test('getById returns affirmation', () {
      final all = service.allAffirmations;
      final first = all.first;
      final found = service.getById(first.id);
      expect(found, isNotNull);
      expect(found!.id, first.id);
    });

    test('getById returns null for non-existent', () {
      final found = service.getById('non_existent');
      expect(found, isNull);
    });

    test('getDailyAffirmation returns consistent result same day', () {
      final first = service.getDailyAffirmation();
      final second = service.getDailyAffirmation();
      expect(first.id, second.id);
    });

    test('favorites CRUD works', () async {
      final id = service.allAffirmations.first.id;
      expect(service.isFavorite(id), false);

      await service.toggleFavorite(id);
      expect(service.isFavorite(id), true);

      final favorites = service.getFavorites();
      expect(favorites.length, 1);
      expect(favorites.first.isFavorite, true);

      await service.toggleFavorite(id);
      expect(service.isFavorite(id), false);
      expect(service.getFavorites().length, 0);
    });

    test('daily view count tracks correctly', () async {
      expect(service.getDailyViewCount(), 0);
      await service.incrementDailyViewCount();
      expect(service.getDailyViewCount(), 1);
      await service.incrementDailyViewCount();
      expect(service.getDailyViewCount(), 2);
    });
  });
}
