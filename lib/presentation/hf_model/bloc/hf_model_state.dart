import 'package:swiss_ai/data/hf_model/model/hf_model.dart';
import 'package:swiss_ai/presentation/hf_model/bloc/hf_model_error.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'hf_model_state.freezed.dart';

@freezed
sealed class HfModelState with _$HfModelState {
  const factory HfModelState.models({
    required DataState<List<HfModel>, HfModelError> data,
    required bool isLoading,
    String? selectedId,
  }) = _HfModels;
}
