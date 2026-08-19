import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swiss_ai/data/recording/model/recording.dart';
import 'package:swiss_ai/data/recording/repository/recording_repository.dart';
import 'package:swiss_ai/data/shared/model/error/data_error.dart';
import 'package:swiss_ai/presentation/recording/bloc/recording_error.dart';
import 'package:swiss_ai/presentation/recording/bloc/recording_event.dart';
import 'package:swiss_ai/presentation/recording/bloc/recording_state.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:logging_flutter/logging_flutter.dart';

class RecordingBloc extends Bloc<RecordingEvent, RecordingState> {
  final RecordingRepository _recordingRepository;

  RecordingBloc(this._recordingRepository)
      : super(const RecordingState.recordings(
          data: DataState.success(data: []),
          isCapturing: false,
        )) {
    on<RecordingEvent>((event, emit) async {
      await event.when(
        capture: (title) => _capture(emit, title),
        clear: () => _clear(emit),
      );
    });
  }

  Future<void> _capture(
    Emitter<RecordingState> emit,
    String title,
  ) async {
    final List<Recording> current = switch (state.data) {
      Success(:final data) => data,
      _ => const [],
    };
    emit(RecordingState.recordings(
      data: DataState.success(data: current),
      isCapturing: true,
    ));
    try {
      final recordings = await _recordingRepository.capture(title: title);
      emit(RecordingState.recordings(
        data: DataState.success(data: recordings),
        isCapturing: false,
      ));
    } on DataError catch (e) {
      Flogger.w("Error capturing recording: $e");
      emit(RecordingState.recordings(
        data: DataState.failure(
          reason: RecordingError.unknown(reason: e.toString()),
        ),
        isCapturing: false,
      ));
    } catch (e) {
      Flogger.w("Unexpected error capturing recording: $e");
      emit(RecordingState.recordings(
        data: DataState.failure(
          reason: RecordingError.unknown(reason: e.toString()),
        ),
        isCapturing: false,
      ));
    }
  }

  Future<void> _clear(Emitter<RecordingState> emit) async {
    await _recordingRepository.clear();
    emit(const RecordingState.recordings(
      data: DataState.success(data: []),
      isCapturing: false,
    ));
  }
}
