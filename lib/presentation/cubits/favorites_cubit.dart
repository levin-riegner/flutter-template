import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:affirmup/data/models/models.dart';
import 'package:affirmup/data/services/services.dart';

part 'favorites_cubit.freezed.dart';

@freezed
abstract class FavoritesState with _$FavoritesState {
  const factory FavoritesState({
    @Default([]) List<Affirmation> favorites,
  }) = _FavoritesState;
}

class FavoritesCubit extends Cubit<FavoritesState> {
  final AffirmationService _affirmationService;

  FavoritesCubit({
    required AffirmationService affirmationService,
  })  : _affirmationService = affirmationService,
        super(const FavoritesState());

  void load() {
    final favorites = _affirmationService.getFavorites();
    emit(state.copyWith(favorites: favorites));
  }

  Future<void> removeFavorite(String id) async {
    await _affirmationService.toggleFavorite(id);
    load();
  }
}
