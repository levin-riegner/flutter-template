import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_event.freezed.dart';

@freezed
sealed class QuizEvent with _$QuizEvent {
  const factory QuizEvent.generate({
    required String document,
    @Default(5) int count,
  }) = QuizGenerate;

  const factory QuizEvent.saveAsDeck({required String deckName}) =
      QuizSaveAsDeck;

  const factory QuizEvent.reset() = QuizReset;
}
