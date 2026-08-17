import 'package:swiss_ai/data/capture/repository/capture_repository.dart';
import 'package:swiss_ai/presentation/capture/bloc/capture_error.dart';
import 'package:swiss_ai/presentation/capture/bloc/capture_event.dart';
import 'package:swiss_ai/presentation/capture/bloc/capture_state.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging_flutter/logging_flutter.dart';

class CaptureBloc extends Bloc<CaptureEvent, CaptureState> {
  final CaptureRepository _repository;

  CaptureBloc(this._repository)
      : super(const CaptureState(
          data: DataState.idle(),
        )) {
    on<CaptureEvent>((event, emit) async {
      await event.when(
        pick: (path) => _transcribe(emit, path),
        retry: () async {
          if (state.imagePath.isNotEmpty) {
            await _transcribe(emit, state.imagePath);
          }
        },
        reset: () async => _reset(emit),
      );
    });
  }

  void _reset(Emitter<CaptureState> emit) {
    emit(const CaptureState(data: DataState.idle()));
  }

  Future<void> _transcribe(Emitter<CaptureState> emit, String path) async {
    emit(state.copyWith(isTranscribing: true, imagePath: path));
    try {
      final text = await _repository.transcribe(path);
      emit(state.copyWith(
        isTranscribing: false,
        data: DataState.success(data: text),
      ));
    } catch (e) {
      Flogger.w('Transcription failed: $e');
      final msg = e.toString();
      final reason = msg.contains('No such file') ||
              msg.contains('file not found')
          ? const CaptureError.fileNotFound()
          : CaptureError.visionUnavailable(reason: msg);
      emit(state.copyWith(
        isTranscribing: false,
        data: DataState.failure(reason: reason),
      ));
    }
  }
}
