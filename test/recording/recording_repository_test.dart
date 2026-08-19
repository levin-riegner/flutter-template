import 'package:swiss_ai/data/recording/repository/recording_repository.dart';
import 'package:swiss_ai/data/recording/service/local/recording_db_service.dart';
import 'package:swiss_ai/data/recording/service/remote/recording_api_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/scaffolding.dart';

class _MockApiService extends Mock implements RecordingApiService {}

void main() {
  group("RecordingRepository", () {
    final dbService = RecordingDbService();
    final apiService = _MockApiService();
    final recordingRepository = RecordingRepository(apiService, dbService);
    setUp(() {
      reset(apiService);
      dbService.clear();
    });

    test("should append a transcribed recording on capture", () async {
      when(() => apiService.transcribe(
          audioBytes: any(named: 'audioBytes'),
          title: any(named: 'title'))).thenAnswer((_) async => "Notes");
      final recordings =
          await recordingRepository.capture(title: "Sprint sync");
      assert(recordings.length == 1);
      assert(recordings[0].title == "Sprint sync");
      assert(recordings[0].transcript == "Notes");
    });
  });
}
