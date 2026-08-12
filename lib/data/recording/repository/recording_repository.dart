import 'package:color_picker/data/recording/model/recording.dart';
import 'package:color_picker/data/recording/service/local/recording_db_service.dart';
import 'package:color_picker/data/recording/service/remote/recording_api_service.dart';
import 'package:logging_flutter/logging_flutter.dart';

class RecordingRepository {
  final RecordingApiService _apiService;
  final RecordingDbService _dbService;
  int _idCounter = 0;

  RecordingRepository(
    this._apiService,
    this._dbService,
  );

  Future<List<Recording>> getRecordings() async {
    return _dbService.getRecordings();
  }

  /// Captures a meeting segment, transcribes it on-device, persists it, and
  /// returns the recorded list.
  Future<List<Recording>> capture({
    required String title,
    List<int>? audioBytes,
  }) async {
    Flogger.i("Capturing recording: $title");
    final transcript = await _apiService.transcribe(
      audioBytes: audioBytes,
      title: title,
    );
    final recording = Recording(
      id: '${_idCounter++}',
      title: title,
      transcript: transcript,
      capturedAt: DateTime.now(),
    );
    await _dbService.saveRecording(recording);
    return _dbService.getRecordings();
  }

  Future<void> clear() async {
    await _dbService.clear();
  }
}
