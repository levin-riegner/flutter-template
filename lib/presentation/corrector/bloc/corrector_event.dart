import 'package:freezed_annotation/freezed_annotation.dart';

part 'corrector_event.freezed.dart';

@freezed
sealed class CorrectorEvent with _$CorrectorEvent {
  const factory CorrectorEvent.correct({required String content}) =
      CorrectorEventCorrect;
}
