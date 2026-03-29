import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:affirmup/data/models/models.dart';
import 'package:affirmup/data/services/services.dart';

part 'custom_affirmation_cubit.freezed.dart';

@freezed
abstract class CustomAffirmationState with _$CustomAffirmationState {
  const factory CustomAffirmationState({
    @Default([]) List<Affirmation> customAffirmations,
    @Default([]) List<String> aiSuggestions,
    @Default('') String currentText,
    @Default(false) bool saved,
  }) = _CustomAffirmationState;
}

class CustomAffirmationCubit extends Cubit<CustomAffirmationState> {
  final CustomAffirmationService _customService;

  CustomAffirmationCubit({
    required CustomAffirmationService customService,
  })  : _customService = customService,
        super(const CustomAffirmationState());

  void load() {
    final customs = _customService.getCustomAffirmations();
    final suggestions = _customService.getAiSuggestions('');
    emit(state.copyWith(
      customAffirmations: customs,
      aiSuggestions: suggestions,
    ));
  }

  void updateText(String text) {
    final suggestions = _customService.getAiSuggestions(text);
    emit(state.copyWith(
      currentText: text,
      aiSuggestions: suggestions,
      saved: false,
    ));
  }

  Future<void> save() async {
    if (state.currentText.trim().isEmpty) return;
    await _customService.saveCustomAffirmation(state.currentText.trim());
    final customs = _customService.getCustomAffirmations();
    emit(state.copyWith(
      customAffirmations: customs,
      currentText: '',
      saved: true,
    ));
  }

  Future<void> delete(String id) async {
    await _customService.deleteCustomAffirmation(id);
    final customs = _customService.getCustomAffirmations();
    emit(state.copyWith(customAffirmations: customs));
  }
}
