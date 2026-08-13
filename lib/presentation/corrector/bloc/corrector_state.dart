import 'package:color_picker/data/corrector/model/correction.dart';
import 'package:color_picker/presentation/corrector/bloc/corrector_error.dart';
import 'package:color_picker/presentation/shared/util/data_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'corrector_state.freezed.dart';

@freezed
sealed class CorrectorState with _$CorrectorState {
  const factory CorrectorState.correct({
    required DataState<Correction, CorrectorError> data,
    required bool isCorrecting,
  }) = _Correct;
}
