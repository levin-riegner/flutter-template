import 'package:swiss_ai/presentation/capture/bloc/capture_error.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'capture_state.freezed.dart';

@freezed
sealed class CaptureState with _$CaptureState {
  const factory CaptureState({
    required DataState<String, CaptureError> data,
    @Default(false) bool isTranscribing,
    @Default('') String imagePath,
  }) = _CaptureState;
}
