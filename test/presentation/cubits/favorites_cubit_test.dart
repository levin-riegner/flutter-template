import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:affirmup/data/services/services.dart';
import 'package:affirmup/presentation/cubits/favorites_cubit.dart';

void main() {
  late StorageService storage;
  late AffirmationService affirmationService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storage = StorageService(prefs);
    affirmationService = AffirmationService(storage);
  });

  FavoritesCubit createCubit() => FavoritesCubit(
        affirmationService: affirmationService,
      );

  group('FavoritesCubit', () {
    test('initial state is empty', () {
      final cubit = createCubit();
      expect(cubit.state.favorites, isEmpty);
      cubit.close();
    });

    blocTest<FavoritesCubit, FavoritesState>(
      'load with no favorites returns empty',
      build: createCubit,
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        expect(cubit.state.favorites, isEmpty);
      },
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'load after adding favorite returns it',
      build: createCubit,
      act: (cubit) async {
        final id = affirmationService.allAffirmations.first.id;
        await affirmationService.toggleFavorite(id);
        cubit.load();
      },
      verify: (cubit) {
        expect(cubit.state.favorites.length, 1);
      },
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'removeFavorite removes from list',
      build: createCubit,
      act: (cubit) async {
        final id = affirmationService.allAffirmations.first.id;
        await affirmationService.toggleFavorite(id);
        cubit.load();
        await cubit.removeFavorite(id);
      },
      verify: (cubit) {
        expect(cubit.state.favorites, isEmpty);
      },
    );
  });
}
