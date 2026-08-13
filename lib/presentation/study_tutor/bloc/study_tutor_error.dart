import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_tutor_error.freezed.dart';

@freezed
sealed class StudyTutorError with _$StudyTutorError {
  const factory StudyTutorError.deckEmpty({String? reason}) = _DeckEmpty;

  const factory StudyTutorError.unknown({String? reason}) = _Unknown;
}
