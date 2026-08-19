import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_error.freezed.dart';

@freezed
sealed class StudyError with _$StudyError {
  const factory StudyError.deckNotFound({required String deckName}) =
      _DeckNotFound;

  const factory StudyError.unknown({String? reason}) = _Unknown;
}
