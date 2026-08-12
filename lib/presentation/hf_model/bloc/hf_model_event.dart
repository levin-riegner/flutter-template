import 'package:freezed_annotation/freezed_annotation.dart';

part 'hf_model_event.freezed.dart';

@freezed
sealed class HfModelEvent with _$HfModelEvent {
  const factory HfModelEvent.refresh() = HfModelEventRefresh;

  const factory HfModelEvent.select({required String modelId}) =
      HfModelEventSelect;

  const factory HfModelEvent.clear() = HfModelEventClear;
}
