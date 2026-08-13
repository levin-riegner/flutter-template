import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_tutor_event.freezed.dart';

@freezed
sealed class StudyTutorEvent with _$StudyTutorEvent {
  const factory StudyTutorEvent.startTutoring({required String deckName}) =
      StudyTutorEventStartTutoring;

  const factory StudyTutorEvent.ask({required String question}) =
      StudyTutorEventAsk;
}
