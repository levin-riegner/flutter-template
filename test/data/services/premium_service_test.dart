import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:affirmup/data/models/affirmation_category.dart';
import 'package:affirmup/data/services/services.dart';

void main() {
  late StorageService storage;
  late PremiumService service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storage = StorageService(prefs);
    service = PremiumService(storage);
  });

  group('PremiumService', () {
    test('starts as not premium', () {
      expect(service.isPremium(), false);
    });

    test('setPremium changes state', () async {
      await service.setPremium(true);
      expect(service.isPremium(), true);
    });

    test('purchasePremium sets premium', () async {
      final result = await service.purchasePremium();
      expect(result, true);
      expect(service.isPremium(), true);
    });

    test('free user only has selfLove category', () {
      final categories = service.getAvailableCategories();
      expect(categories.length, 1);
      expect(categories.first, AffirmationCategory.selfLove);
    });

    test('premium user has all categories', () async {
      await service.setPremium(true);
      final categories = service.getAvailableCategories();
      expect(categories.length, 7);
    });

    test('isCategoryAvailable - free user', () {
      expect(service.isCategoryAvailable(AffirmationCategory.selfLove), true);
      expect(service.isCategoryAvailable(AffirmationCategory.abundance), false);
      expect(service.isCategoryAvailable(AffirmationCategory.career), false);
    });

    test('isCategoryAvailable - premium user', () async {
      await service.setPremium(true);
      for (final cat in AffirmationCategory.values) {
        expect(service.isCategoryAvailable(cat), true);
      }
    });

    test('canViewMore - free tier limit', () {
      expect(service.canViewMore(0), true);
      expect(service.canViewMore(2), true);
      expect(service.canViewMore(3), false);
      expect(service.canViewMore(10), false);
    });

    test('canViewMore - premium unlimited', () async {
      await service.setPremium(true);
      expect(service.canViewMore(100), true);
    });

    test('mirror mode locked for free', () {
      expect(service.isMirrorModeAvailable(), false);
    });

    test('mirror mode available for premium', () async {
      await service.setPremium(true);
      expect(service.isMirrorModeAvailable(), true);
    });

    test('custom builder locked for free', () {
      expect(service.isCustomBuilderAvailable(), false);
    });

    test('custom builder available for premium', () async {
      await service.setPremium(true);
      expect(service.isCustomBuilderAvailable(), true);
    });

    test('premium price is 6', () {
      expect(PremiumService.premiumPrice, 6.0);
    });

    test('free daily limit is 3', () {
      expect(PremiumService.freeDailyLimit, 3);
    });
  });
}
