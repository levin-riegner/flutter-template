import 'package:bloc_test/bloc_test.dart';
import 'package:color_picker/data/study/model/flashcard.dart';
import 'package:color_picker/data/study_tutor/model/tutor_session.dart';
import 'package:color_picker/data/study_tutor/repository/study_tutor_repository.dart';
import 'package:color_picker/presentation/study_tutor/bloc/study_tutor_bloc.dart';
import 'package:color_picker/presentation/study_tutor/bloc/study_tutor_error.dart';
import 'package:color_picker/presentation/study_tutor/bloc/study_tutor_event.dart';
import 'package:color_picker/presentation/study_tutor/bloc/study_tutor_state.dart';
import 'package:color_picker/presentation/shared/util/data_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements StudyTutorRepository {}

void main() {
  final cards = [
    Flashcard(
      id: 'f1',
      front: 'What is a widget?',
      back: 'A widget is a UI element.',
      deckName: 'Flutter Basics',
      dueAt: DateTime(2026, 1, 1),
      repetitions: 0,
    ),
  ];
  final session = TutorSession(
    deckName: 'Flutter Basics',
    cards: cards,
    welcome: 'Ready to review widgets?',
    personaId: 'teacher',
  );

  group('StudyTutorBloc', () {
    late _MockRepository mockRepository;
    setUp(() {
      mockRepository = _MockRepository();
      reset(mockRepository);
    });

    blocTest<StudyTutorBloc, StudyTutorState>(
      'startTutoring emits loading then the welcome dialogue',
      setUp: () {
        when(() => mockRepository.startTutorSession(any()))
            .thenAnswer((_) async => session);
      },
      build: () => StudyTutorBloc(mockRepository),
      act: (bloc) => bloc.add(const StudyTutorEvent.startTutoring(
          deckName: 'Flutter Basics')),
      expect: () => [
        const StudyTutorState.tutoring(
            session: DataState.loading(), dialogue: [], isAsking: false),
        StudyTutorState.tutoring(
          session: DataState.success(data: session),
          dialogue: ['Ready to review widgets?'],
          isAsking: false,
        ),
      ],
    );

    blocTest<StudyTutorBloc, StudyTutorState>(
      'startTutoring emits an unknown failure on error',
      setUp: () {
        when(() => mockRepository.startTutorSession(any()))
            .thenThrow(StateError('boom'));
      },
      build: () => StudyTutorBloc(mockRepository),
      act: (bloc) => bloc.add(const StudyTutorEvent.startTutoring(
          deckName: 'Flutter Basics')),
      expect: () => [
        const StudyTutorState.tutoring(
            session: DataState.loading(), dialogue: [], isAsking: false),
        const StudyTutorState.tutoring(
          session: DataState.failure(
              reason: StudyTutorError.unknown(reason: 'Bad state: boom')),
          dialogue: [],
          isAsking: false,
        ),
      ],
    );
  });
}
