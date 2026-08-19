import 'package:swiss_ai/data/study/model/flashcard.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:swiss_ai/presentation/study/bloc/study_error.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_state.freezed.dart';

@freezed
sealed class StudyState with _$StudyState {
  const factory StudyState.studying({
    required DataState<List<Flashcard>, StudyError> data,
    required bool isFlipped,
    required int index,
  }) = _Studying;
}
