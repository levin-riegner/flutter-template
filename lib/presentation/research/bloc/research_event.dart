import 'package:freezed_annotation/freezed_annotation.dart';

part 'research_event.freezed.dart';

@freezed
sealed class ResearchEvent with _$ResearchEvent {
  const factory ResearchEvent.start({required String question}) =
      ResearchStart;

  const factory ResearchEvent.cancel() = ResearchCancel;

  const factory ResearchEvent.reset() = ResearchReset;
}
