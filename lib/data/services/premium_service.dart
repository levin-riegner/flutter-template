import 'package:affirmup/data/models/affirmation_category.dart';
import 'package:affirmup/data/services/storage_service.dart';

class PremiumService {
  final StorageService _storage;

  PremiumService(this._storage);

  static const double premiumPrice = 6.0;
  static const String premiumCurrency = '€';
  static const int freeDailyLimit = 3;

  bool isPremium() {
    return _storage.getBool(StorageService.isPremium) ?? false;
  }

  Future<void> setPremium(bool value) async {
    await _storage.setBool(StorageService.isPremium, value);
  }

  /// Mock purchase
  Future<bool> purchasePremium() async {
    await setPremium(true);
    return true;
  }

  /// Mock restore
  Future<bool> restorePurchase() async {
    // In production, would check with store
    return isPremium();
  }

  bool isCategoryAvailable(AffirmationCategory category) {
    if (isPremium()) return true;
    return category == AffirmationCategory.selfLove;
  }

  List<AffirmationCategory> getAvailableCategories() {
    if (isPremium()) return AffirmationCategory.values.toList();
    return [AffirmationCategory.selfLove];
  }

  bool canViewMore(int currentDailyViews) {
    if (isPremium()) return true;
    return currentDailyViews < freeDailyLimit;
  }

  bool isMirrorModeAvailable() => isPremium();

  bool isCustomBuilderAvailable() => isPremium();

  // ─── Premium Features List ───

  static const List<String> freeFeatures = [
    'Self-Love affirmations',
    '3 affirmations per day',
    'Basic streak tracking',
    'Favorites list',
  ];

  static const List<String> premiumFeatures = [
    'All 7 categories unlocked',
    'Unlimited affirmations',
    'Mirror Mode',
    'Custom affirmation builder',
    'AI suggestions',
    'No ads',
    'Priority support',
  ];
}
