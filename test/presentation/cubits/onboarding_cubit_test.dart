import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:affirmup/data/services/services.dart';
import 'package:affirmup/presentation/cubits/onboarding_cubit.dart';

void main() {
  late StorageService storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storage = StorageService(prefs);
  });

  OnboardingCubit createCubit() => OnboardingCubit(storage: storage);

  group('OnboardingCubit', () {
    test('initial state is page 0', () {
      final cubit = createCubit();
      expect(cubit.state.currentPage, 0);
      expect(cubit.state.completed, false);
      cubit.close();
    });

    blocTest<OnboardingCubit, OnboardingState>(
      'nextPage advances',
      build: createCubit,
      act: (cubit) => cubit.nextPage(),
      expect: () => [
        const OnboardingState(currentPage: 1),
      ],
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'nextPage does not exceed totalPages',
      build: createCubit,
      act: (cubit) {
        cubit.nextPage();
        cubit.nextPage();
        cubit.nextPage();
        cubit.nextPage(); // should not go to 4
      },
      verify: (cubit) {
        expect(cubit.state.currentPage, 3);
      },
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'previousPage goes back',
      build: createCubit,
      act: (cubit) {
        cubit.nextPage();
        cubit.previousPage();
      },
      verify: (cubit) {
        expect(cubit.state.currentPage, 0);
      },
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'previousPage does not go below 0',
      build: createCubit,
      act: (cubit) => cubit.previousPage(),
      expect: () => [],
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'completeOnboarding sets completed',
      build: createCubit,
      act: (cubit) => cubit.completeOnboarding(),
      verify: (cubit) {
        expect(cubit.state.completed, true);
        expect(cubit.isOnboardingCompleted(), true);
      },
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'goToPage jumps to specific page',
      build: createCubit,
      act: (cubit) => cubit.goToPage(2),
      expect: () => [
        const OnboardingState(currentPage: 2),
      ],
    );
  });
}
