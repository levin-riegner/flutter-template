import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_error.freezed.dart';

@freezed
sealed class QuizError with _$QuizError {
  const factory QuizError.emptyInput() = EmptyInput;

  const factory QuizError.emptyDeckName() = EmptyDeckName;

  const factory QuizError.unknown({required String reason}) = Unknown;
}
