import 'package:color_picker/data/recording/model/recording.dart';

/// Local persistence for recorded meetings.
///
/// Pure-Dart in-memory store (same convention as ChatDbService) so the
/// recording feature is testable on the host without native plugins.
class RecordingDbService {
  final List<Recording> _store = [];

  Future<List<Recording>> getRecordings() async {
    return List.unmodifiable(_store);
  }

  Stream<List<Recording>> recordings() async* {
    yield List.unmodifiable(_store);
  }

  Future<void> saveRecording(Recording recording) async {
    _store.add(recording);
  }

  Future<void> clear() async {
    _store.clear();
  }
}
