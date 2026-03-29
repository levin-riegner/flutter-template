import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:affirmup/data/services/services.dart';
import 'package:affirmup/presentation/cubits/settings_cubit.dart';

void main() {
  late StorageService storage;
  late PremiumService premiumService;
  late NotificationService notificationService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storage = StorageService(prefs);
    premiumService = PremiumService(storage);
    notificationService = NotificationService(storage);
  });

  SettingsCubit createCubit() => SettingsCubit(
        premiumService: premiumService,
        notificationService: notificationService,
      );

  group('SettingsCubit', () {
    test('initial state defaults', () {
      final cubit = createCubit();
      expect(cubit.state.isPremium, false);
      expect(cubit.state.notificationsEnabled, true);
      expect(cubit.state.quietHoursEnabled, false);
      cubit.close();
    });

    blocTest<SettingsCubit, SettingsState>(
      'load populates state',
      build: createCubit,
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        expect(cubit.state.isPremium, false);
        expect(cubit.state.notificationsEnabled, true);
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'toggleNotifications changes state',
      build: createCubit,
      act: (cubit) async {
        cubit.load();
        await cubit.toggleNotifications(false);
      },
      verify: (cubit) {
        expect(cubit.state.notificationsEnabled, false);
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'toggleQuietHours changes state',
      build: createCubit,
      act: (cubit) async {
        cubit.load();
        await cubit.toggleQuietHours(true);
      },
      verify: (cubit) {
        expect(cubit.state.quietHoursEnabled, true);
      },
    );
  });
}
