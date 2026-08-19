import 'package:freezed_annotation/freezed_annotation.dart';

part 'research_error.freezed.dart';

@freezed
sealed class ResearchError with _$ResearchError {
  const factory ResearchError.emptyQuestion() = EmptyQuestion;

  const factory ResearchError.noSources() = NoSources;

  const factory ResearchError.cancelled() = Cancelled;

  const factory ResearchError.unknown({required String reason}) = Unknown;
}
