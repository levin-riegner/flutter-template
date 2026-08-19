import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_event.freezed.dart';

@freezed
sealed class StudyEvent with _$StudyEvent {
  const factory StudyEvent.openDeck({required String deckName}) =
      StudyEventOpenDeck;

  const factory StudyEvent.flip() = StudyEventFlip;

  const factory StudyEvent.answer({required bool correct}) = StudyEventAnswer;
}
