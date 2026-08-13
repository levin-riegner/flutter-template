import 'package:bloc_test/bloc_test.dart';
import 'package:color_picker/data/focus/model/focus_session.dart';
import 'package:color_picker/data/focus/repository/focus_repository.dart';
import 'package:color_picker/presentation/focus/bloc/focus_bloc.dart';
import 'package:color_picker/presentation/focus/bloc/focus_error.dart';
import 'package:color_picker/presentation/focus/bloc/focus_event.dart';
import 'package:color_picker/presentation/focus/bloc/focus_state.dart';
import 'package:color_picker/presentation/shared/util/data_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements FocusRepository {}

void main() {
  group('FocusBloc', () {
    late _MockRepository mockRepository;
    setUp(() {
      mockRepository = _MockRepository();
      reset(mockRepository);
      when(() => mockRepository.getSessions()).thenAnswer((_) async => []);
    });

    blocTest<FocusBloc, FocusState>(
      'loadSessions emits the stored sessions',
      setUp: () {
        when(() => mockRepository.getSessions()).thenAnswer((_) async => [
          const FocusSession(
              id: '1',
              label: 'Deep work',
              durationSeconds: 1500,
              elapsedSeconds: 0,
              isRunning: false),
        ]);
      },
      build: () => FocusBloc(mockRepository),
      act: (bloc) => bloc.add(const FocusEvent.loadSessions()),
      expect: () => [
        const FocusState.focus(
          sessions: DataState.success(data: [
            FocusSession(
                id: '1',
                label: 'Deep work',
                durationSeconds: 1500,
                elapsedSeconds: 0,
                isRunning: false),
          ]),
          activeSessionId: null),
      ],
    );

    blocTest<FocusBloc, FocusState>(
      'createSession with an empty label emits emptyLabel failure',
      build: () => FocusBloc(mockRepository),
      act: (bloc) => bloc.add(const FocusEvent.createSession(
          label: '   ', durationSeconds: 1500)),
      expect: () => [
        const FocusState.focus(
            sessions: DataState.failure(reason: FocusError.emptyLabel()),
            activeSessionId: null),
      ],
    );

    blocTest<FocusBloc, FocusState>(
      'createSession appends a new session',
      setUp: () {
        when(() => mockRepository.createSession(any(), durationSeconds: any(named: 'durationSeconds')))
            .thenAnswer((_) async =>
                const FocusSession(
                    id: '1',
                    label: 'Focus',
                    durationSeconds: 1500,
                    elapsedSeconds: 0,
                    isRunning: false));
        when(() => mockRepository.getSessions()).thenAnswer((_) async => [
          const FocusSession(
              id: '1',
              label: 'Focus',
              durationSeconds: 1500,
              elapsedSeconds: 0,
              isRunning: false),
        ]);
      },
      build: () => FocusBloc(mockRepository),
      act: (bloc) => bloc.add(const FocusEvent.createSession(
          label: 'Focus', durationSeconds: 1500)),
      expect: () => [
        const FocusState.focus(
          sessions: DataState.success(data: [
            FocusSession(
                id: '1',
                label: 'Focus',
                durationSeconds: 1500,
                elapsedSeconds: 0,
                isRunning: false),
          ]),
          activeSessionId: null),
      ],
    );
  });
}
