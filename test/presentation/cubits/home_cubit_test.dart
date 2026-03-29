import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:affirmup/data/services/services.dart';
import 'package:affirmup/presentation/cubits/home_cubit.dart';

void main() {
  late StorageService storage;
  late AffirmationService affirmationService;
  late DailyRoutineService dailyRoutineService;
  late PremiumService premiumService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storage = StorageService(prefs);
    affirmationService = AffirmationService(storage);
    dailyRoutineService = DailyRoutineService(storage);
    premiumService = PremiumService(storage);
  });

  HomeCubit createCubit() => HomeCubit(
        affirmationService: affirmationService,
        dailyRoutineService: dailyRoutineService,
        premiumService: premiumService,
      );

  group('HomeCubit', () {
    test('initial state', () {
      final cubit = createCubit();
      expect(cubit.state.dailyAffirmation, isNull);
      expect(cubit.state.currentStreak, 0);
      expect(cubit.state.morningCompleted, false);
      expect(cubit.state.eveningCompleted, false);
      cubit.close();
    });

    blocTest<HomeCubit, HomeState>(
      'load populates state',
      build: createCubit,
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        expect(cubit.state.dailyAffirmation, isNotNull);
        expect(cubit.state.categories, isNotEmpty);
      },
    );

    blocTest<HomeCubit, HomeState>(
      'completeMorning updates state',
      build: createCubit,
      act: (cubit) async {
        cubit.load();
        await cubit.completeMorning();
      },
      verify: (cubit) {
        expect(cubit.state.morningCompleted, true);
        expect(cubit.state.currentStreak, greaterThan(0));
      },
    );

    blocTest<HomeCubit, HomeState>(
      'completeEvening updates state',
      build: createCubit,
      act: (cubit) async {
        cubit.load();
        await cubit.completeEvening();
      },
      verify: (cubit) {
        expect(cubit.state.eveningCompleted, true);
      },
    );
  });
}
