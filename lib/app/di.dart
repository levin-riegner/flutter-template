import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:affirmup/data/services/services.dart';

final getIt = GetIt.instance;

abstract class Dependencies {
  static Future<void> register() async {
    // Shared Preferences
    final prefs = await SharedPreferences.getInstance();

    // Storage Service
    final storageService = StorageService(prefs);
    getIt.registerSingleton<StorageService>(storageService);

    // Services
    getIt.registerSingleton<AffirmationService>(
      AffirmationService(storageService),
    );
    getIt.registerSingleton<DailyRoutineService>(
      DailyRoutineService(storageService),
    );
    getIt.registerSingleton<CustomAffirmationService>(
      CustomAffirmationService(storageService),
    );
    getIt.registerSingleton<PremiumService>(
      PremiumService(storageService),
    );
    getIt.registerSingleton<NotificationService>(
      NotificationService(storageService),
    );
    getIt.registerSingleton<ReviewPromptService>(
      ReviewPromptService(storageService),
    );
  }
}
