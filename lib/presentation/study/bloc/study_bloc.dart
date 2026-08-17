import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swiss_ai/data/shared/model/error/data_error.dart';
import 'package:swiss_ai/data/study/model/flashcard.dart';
import 'package:swiss_ai/data/study/repository/study_repository.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:swiss_ai/presentation/study/bloc/study_error.dart';
import 'package:swiss_ai/presentation/study/bloc/study_event.dart';
import 'package:swiss_ai/presentation/study/bloc/study_state.dart';
import 'package:logging_flutter/logging_flutter.dart';

class StudyBloc extends Bloc<StudyEvent, StudyState> {
  final StudyRepository _studyRepository;

  StudyBloc(this._studyRepository)
      : super(const StudyState.studying(
          data: DataState.success(data: []),
          isFlipped: false,
          index: 0,
        )) {
    on<StudyEvent>((event, emit) async {
      await event.when(
        openDeck: (deckName) => _openDeck(emit, deckName),
        flip: () => _flip(emit),
        answer: (correct) => _answer(emit, correct),
      );
    });
  }

  Future<void> _openDeck(
    Emitter<StudyState> emit,
    String deckName,
  ) async {
    emit(StudyState.studying(
      data: DataState.loading(),
      isFlipped: false,
      index: 0,
    ));
    try {
      final cards = await _studyRepository.getDeck(deckName);
      emit(StudyState.studying(
        data: DataState.success(data: cards),
        isFlipped: false,
        index: 0,
      ));
    } on DataError catch (e) {
      Flogger.w("Error opening deck: $e");
      emit(StudyState.studying(
        data: DataState.failure(
          reason: StudyError.unknown(reason: e.toString()),
        ),
        isFlipped: false,
        index: 0,
      ));
    } catch (e) {
      Flogger.w("Unexpected error opening deck: $e");
      emit(StudyState.studying(
        data: DataState.failure(
          reason: StudyError.unknown(reason: e.toString()),
        ),
        isFlipped: false,
        index: 0,
      ));
    }
  }

  Future<void> _flip(Emitter<StudyState> emit) async {
    emit(StudyState.studying(
      data: state.data,
      isFlipped: !state.isFlipped,
      index: state.index,
    ));
  }

  Future<void> _answer(Emitter<StudyState> emit, bool correct) async {
    final List<Flashcard> cards = switch (state.data) {
      Success(:final data) => data,
      _ => const [],
    };
    if (cards.isEmpty || state.index >= cards.length) {
      return;
    }
    final current = cards[state.index];
    try {
      await _studyRepository.answerCard(id: current.id, correct: correct);
    } on DataError catch (e) {
      Flogger.w("Error answering card: $e");
    } catch (e) {
      Flogger.w("Unexpected error answering card: $e");
    }
    final nextIndex = state.index + 1 < cards.length
        ? state.index + 1
        : state.index;
    emit(StudyState.studying(
      data: state.data,
      isFlipped: false,
      index: nextIndex,
    ));
  }
}
