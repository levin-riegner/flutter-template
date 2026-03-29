import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:affirmup/data/models/models.dart';
import 'package:affirmup/data/services/services.dart';

part 'home_cubit.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    Affirmation? dailyAffirmation,
    @Default([]) List<AffirmationCategory> categories,
    @Default(0) int currentStreak,
    @Default(false) bool morningCompleted,
    @Default(false) bool eveningCompleted,
    @Default(false) bool isPremium,
  }) = _HomeState;
}

class HomeCubit extends Cubit<HomeState> {
  final AffirmationService _affirmationService;
  final DailyRoutineService _dailyRoutineService;
  final PremiumService _premiumService;

  HomeCubit({
    required AffirmationService affirmationService,
    required DailyRoutineService dailyRoutineService,
    required PremiumService premiumService,
  })  : _affirmationService = affirmationService,
        _dailyRoutineService = dailyRoutineService,
        _premiumService = premiumService,
        super(const HomeState());

  void load() {
    final daily = _affirmationService.getDailyAffirmation();
    final stats = _dailyRoutineService.getStats();
    final categories = _premiumService.getAvailableCategories();

    emit(state.copyWith(
      dailyAffirmation: daily,
      categories: categories,
      currentStreak: stats.currentStreak,
      morningCompleted: _dailyRoutineService.isMorningCompleted(),
      eveningCompleted: _dailyRoutineService.isEveningCompleted(),
      isPremium: _premiumService.isPremium(),
    ));
  }

  Future<void> completeMorning() async {
    await _dailyRoutineService.completeMorning();
    emit(state.copyWith(morningCompleted: true));
    _updateStreak();
  }

  Future<void> completeEvening() async {
    await _dailyRoutineService.completeEvening();
    emit(state.copyWith(eveningCompleted: true));
    _updateStreak();
  }

  void _updateStreak() {
    final stats = _dailyRoutineService.getStats();
    emit(state.copyWith(currentStreak: stats.currentStreak));
  }
}
