import 'package:color_picker/data/recording/model/recording.dart';
import 'package:color_picker/presentation/recording/bloc/recording_error.dart';
import 'package:color_picker/presentation/shared/util/data_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recording_state.freezed.dart';

@freezed
sealed class RecordingState with _$RecordingState {
  const factory RecordingState.recordings({
    required DataState<List<Recording>, RecordingError> data,
    required bool isCapturing,
  }) = _Recordings;
}
