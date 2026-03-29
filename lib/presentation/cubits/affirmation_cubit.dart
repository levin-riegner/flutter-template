import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:affirmup/data/models/models.dart';
import 'package:affirmup/data/services/services.dart';

part 'affirmation_cubit.freezed.dart';

@freezed
abstract class AffirmationState with _$AffirmationState {
  const factory AffirmationState({
    @Default([]) List<Affirmation> affirmations,
    @Default(0) int currentIndex,
    @Default(false) bool isFavorite,
    AffirmationCategory? category,
  }) = _AffirmationState;
}

class AffirmationCubit extends Cubit<AffirmationState> {
  final AffirmationService _affirmationService;
  final PremiumService _premiumService;

  AffirmationCubit({
    required AffirmationService affirmationService,
    required PremiumService premiumService,
  })  : _affirmationService = affirmationService,
        _premiumService = premiumService,
        super(const AffirmationState());

  void loadCategory(AffirmationCategory category) {
    final affirmations = _affirmationService.getByCategory(category);
    final isFav = affirmations.isNotEmpty
        ? _affirmationService.isFavorite(affirmations.first.id)
        : false;

    emit(state.copyWith(
      affirmations: affirmations,
      currentIndex: 0,
      isFavorite: isFav,
      category: category,
    ));

    _affirmationService.incrementDailyViewCount();
  }

  void next() {
    if (state.affirmations.isEmpty) return;
    final newIndex = (state.currentIndex + 1) % state.affirmations.length;
    final affirmation = state.affirmations[newIndex];

    // Check free tier limit
    if (!_premiumService.isPremium()) {
      final views = _affirmationService.getDailyViewCount();
      if (!_premiumService.canViewMore(views)) return;
      _affirmationService.incrementDailyViewCount();
    }

    emit(state.copyWith(
      currentIndex: newIndex,
      isFavorite: _affirmationService.isFavorite(affirmation.id),
    ));
  }

  void previous() {
    if (state.affirmations.isEmpty) return;
    final newIndex = state.currentIndex == 0
        ? state.affirmations.length - 1
        : state.currentIndex - 1;
    final affirmation = state.affirmations[newIndex];

    emit(state.copyWith(
      currentIndex: newIndex,
      isFavorite: _affirmationService.isFavorite(affirmation.id),
    ));
  }

  Future<void> toggleFavorite() async {
    if (state.affirmations.isEmpty) return;
    final affirmation = state.affirmations[state.currentIndex];
    await _affirmationService.toggleFavorite(affirmation.id);
    emit(state.copyWith(
      isFavorite: _affirmationService.isFavorite(affirmation.id),
    ));
  }

  Affirmation? get currentAffirmation {
    if (state.affirmations.isEmpty) return null;
    return state.affirmations[state.currentIndex];
  }
}
