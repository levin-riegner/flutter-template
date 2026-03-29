import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:affirmup/data/services/storage_service.dart';

part 'onboarding_cubit.freezed.dart';

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(0) int currentPage,
    @Default(false) bool completed,
  }) = _OnboardingState;
}

class OnboardingCubit extends Cubit<OnboardingState> {
  final StorageService _storage;

  OnboardingCubit({required StorageService storage})
      : _storage = storage,
        super(const OnboardingState());

  static const int totalPages = 4;

  void nextPage() {
    if (state.currentPage < totalPages - 1) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    }
  }

  void previousPage() {
    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    }
  }

  void goToPage(int page) {
    if (page >= 0 && page < totalPages) {
      emit(state.copyWith(currentPage: page));
    }
  }

  Future<void> completeOnboarding() async {
    await _storage.setBool(StorageService.onboardingCompleted, true);
    emit(state.copyWith(completed: true));
  }

  bool isOnboardingCompleted() {
    return _storage.getBool(StorageService.onboardingCompleted) ?? false;
  }
}
