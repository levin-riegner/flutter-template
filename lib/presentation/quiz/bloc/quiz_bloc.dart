import 'package:swiss_ai/data/quiz/repository/quiz_repository.dart';
import 'package:swiss_ai/presentation/quiz/bloc/quiz_error.dart';
import 'package:swiss_ai/presentation/quiz/bloc/quiz_event.dart';
import 'package:swiss_ai/presentation/quiz/bloc/quiz_state.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging_flutter/logging_flutter.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepository _repository;

  QuizBloc(this._repository)
      : super(const QuizState(
          data: DataState.idle(),
          isGenerating: false,
          isSaving: false,
        )) {
    on<QuizEvent>((event, emit) async {
      await event.when(
        generate: (document, count) => _generate(emit, document, count),
        saveAsDeck: (deckName) => _saveAsDeck(emit, deckName),
        reset: () async => _reset(emit),
      );
    });
  }

  void _reset(Emitter<QuizState> emit) {
    emit(const QuizState(
      data: DataState.idle(),
      isGenerating: false,
      isSaving: false,
    ));
  }

  Future<void> _generate(
      Emitter<QuizState> emit, String document, int count) async {
    if (document.trim().isEmpty) {
      emit(const QuizState(
        data: DataState.failure(reason: QuizError.emptyInput()),
        isGenerating: false,
        isSaving: false,
      ));
      return;
    }
    emit(state.copyWith(
      data: const DataState.loading(),
      isGenerating: true,
      isSaving: false,
    ));
    try {
      final items = await _repository.generateFromDocument(document,
          count: count);
      emit(QuizState(
        data: DataState.success(data: items),
        isGenerating: false,
        isSaving: false,
      ));
    } catch (e) {
      Flogger.w('Error generating quiz: $e');
      emit(QuizState(
        data: DataState.failure(reason: QuizError.unknown(reason: e.toString())),
        isGenerating: false,
        isSaving: false,
      ));
    }
  }

  Future<void> _saveAsDeck(Emitter<QuizState> emit, String deckName) async {
    if (state.data case Success(:final data)) {
      if (data.isEmpty) return;
      if (deckName.trim().isEmpty) {
        emit(state.copyWith(
          data: const DataState.failure(reason: QuizError.emptyDeckName()),
        ));
        return;
      }
      emit(state.copyWith(isSaving: true));
      try {
        await _repository.saveAsDeck(data, deckName.trim());
        emit(state.copyWith(isSaving: false));
        _reset(emit);
      } catch (e) {
        Flogger.w('Error saving quiz deck: $e');
        emit(state.copyWith(
          isSaving: false,
          data: DataState.failure(
              reason: QuizError.unknown(reason: e.toString())),
        ));
      }
    }
  }
}
