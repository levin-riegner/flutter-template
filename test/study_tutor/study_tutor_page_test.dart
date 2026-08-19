import 'package:swiss_ai/data/study_tutor/model/tutor_session.dart';
import 'package:swiss_ai/data/study_tutor/repository/study_tutor_repository.dart';
import 'package:swiss_ai/presentation/study_tutor/bloc/study_tutor_bloc.dart';
import 'package:swiss_ai/presentation/study_tutor/study_tutor_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements StudyTutorRepository {}

void main() {
  group('StudyTutorPage', () {
    late _MockRepository mockRepository;

    setUp(() {
      mockRepository = _MockRepository();
      reset(mockRepository);
    });

    testWidgets('shows the tutor welcome message after starting', (tester) async {
      when(() => mockRepository.startTutorSession(any())).thenAnswer((_) async =>
          TutorSession(
        deckName: 'Flutter Basics',
        cards: const [],
        welcome: 'Ready to review widgets?',
        personaId: 'teacher',
      ));
      final bloc = StudyTutorBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: StudyTutorPage(deckName: 'Flutter Basics', bloc: bloc)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Ready to review widgets?'), findsOneWidget);
      expect(find.byKey(const ValueKey('study_tutor_input')), findsOneWidget);
      expect(find.byKey(const ValueKey('study_tutor_send')), findsOneWidget);
    });

    testWidgets('shows failure text when tutoring cannot start', (tester) async {
      when(() => mockRepository.startTutorSession(any()))
          .thenThrow(StateError('boom'));
      final bloc = StudyTutorBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: StudyTutorPage(deckName: 'Flutter Basics', bloc: bloc)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Could not start tutoring.'), findsOneWidget);
    });
  });
}
