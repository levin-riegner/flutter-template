import 'package:swiss_ai/data/quiz/model/quiz_item.dart';
import 'package:swiss_ai/presentation/quiz/bloc/quiz_error.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_state.freezed.dart';

@freezed
sealed class QuizState with _$QuizState {
  const factory QuizState({
    required DataState<List<QuizItem>, QuizError> data,
    @Default(false) bool isGenerating,
    @Default(false) bool isSaving,
  }) = _QuizState;
}
