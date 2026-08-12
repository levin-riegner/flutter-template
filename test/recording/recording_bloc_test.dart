import 'package:bloc_test/bloc_test.dart';
import 'package:color_picker/data/recording/model/recording.dart';
import 'package:color_picker/data/recording/repository/recording_repository.dart';
import 'package:color_picker/presentation/recording/bloc/recording_bloc.dart';
import 'package:color_picker/presentation/recording/bloc/recording_error.dart';
import 'package:color_picker/presentation/recording/bloc/recording_event.dart';
import 'package:color_picker/presentation/recording/bloc/recording_state.dart';
import 'package:color_picker/presentation/shared/util/data_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements RecordingRepository {}

void main() {
  group('RecordingBloc', () {
    late _MockRepository mockRepository;
    setUp(() {
      mockRepository = _MockRepository();
      reset(mockRepository);
    });
    group("RecordingEvent.capture", () {
      final recording = Recording(
        id: "0",
        title: "Sprint sync",
        transcript: "Notes",
        capturedAt: DateTime(2026, 8, 12),
      );
      blocTest<RecordingBloc, RecordingState>(
        'should emit capturing state then success with recordings',
        setUp: () => when(() => mockRepository.capture(title: any(named: 'title')))
            .thenAnswer((_) async => [recording]),
        build: () => RecordingBloc(mockRepository),
        act: (bloc) => bloc.add(const RecordingEvent.capture(title: "Sprint")),
        expect: () => [
          const RecordingState.recordings(
              data: DataState.success(data: []), isCapturing: true),
          RecordingState.recordings(
              data: DataState.success(data: [recording]), isCapturing: false),
        ],
      );
      blocTest<RecordingBloc, RecordingState>(
        'should emit failure when capture throws',
        setUp: () => when(() => mockRepository.capture(title: any(named: 'title')))
            .thenThrow(Exception("boom")),
        build: () => RecordingBloc(mockRepository),
        act: (bloc) => bloc.add(const RecordingEvent.capture(title: "Sprint")),
        skip: 1,
        expect: () => [
          RecordingState.recordings(
              data: DataState.failure(
                  reason: RecordingError.unknown(reason: "Exception: boom")),
              isCapturing: false),
        ],
      );
    });

    group("RecordingEvent.clear", () {
      blocTest<RecordingBloc, RecordingState>(
        'should clear recordings',
        setUp: () => when(() => mockRepository.clear())
            .thenAnswer((_) async {}),
        build: () => RecordingBloc(mockRepository),
        act: (bloc) => bloc.add(const RecordingEvent.clear()),
        expect: () => [
          const RecordingState.recordings(
              data: DataState.success(data: []), isCapturing: false),
        ],
      );
    });
  });
}
