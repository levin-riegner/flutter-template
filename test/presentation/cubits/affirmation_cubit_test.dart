import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:affirmup/data/models/affirmation_category.dart';
import 'package:affirmup/data/services/services.dart';
import 'package:affirmup/presentation/cubits/affirmation_cubit.dart';

void main() {
  late StorageService storage;
  late AffirmationService affirmationService;
  late PremiumService premiumService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storage = StorageService(prefs);
    affirmationService = AffirmationService(storage);
    premiumService = PremiumService(storage);
  });

  AffirmationCubit createCubit() => AffirmationCubit(
        affirmationService: affirmationService,
        premiumService: premiumService,
      );

  group('AffirmationCubit', () {
    test('initial state is empty', () {
      final cubit = createCubit();
      expect(cubit.state.affirmations, isEmpty);
      expect(cubit.state.currentIndex, 0);
      expect(cubit.currentAffirmation, isNull);
      cubit.close();
    });

    blocTest<AffirmationCubit, AffirmationState>(
      'loadCategory loads affirmations',
      build: createCubit,
      act: (cubit) => cubit.loadCategory(AffirmationCategory.selfLove),
      verify: (cubit) {
        expect(cubit.state.affirmations, isNotEmpty);
        expect(cubit.state.category, AffirmationCategory.selfLove);
        expect(cubit.currentAffirmation, isNotNull);
      },
    );

    blocTest<AffirmationCubit, AffirmationState>(
      'next advances index',
      build: () {
        premiumService.setPremium(true);
        return createCubit();
      },
      act: (cubit) {
        cubit.loadCategory(AffirmationCategory.selfLove);
        cubit.next();
      },
      verify: (cubit) {
        expect(cubit.state.currentIndex, 1);
      },
    );

    blocTest<AffirmationCubit, AffirmationState>(
      'previous goes back',
      build: () {
        premiumService.setPremium(true);
        return createCubit();
      },
      act: (cubit) {
        cubit.loadCategory(AffirmationCategory.selfLove);
        cubit.next();
        cubit.previous();
      },
      verify: (cubit) {
        expect(cubit.state.currentIndex, 0);
      },
    );

    blocTest<AffirmationCubit, AffirmationState>(
      'toggleFavorite works',
      build: createCubit,
      act: (cubit) async {
        cubit.loadCategory(AffirmationCategory.selfLove);
        await cubit.toggleFavorite();
      },
      verify: (cubit) {
        expect(cubit.state.isFavorite, true);
      },
    );
  });
}
