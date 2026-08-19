import 'package:swiss_ai/data/study/model/flashcard.dart';
import 'package:swiss_ai/data/study/repository/study_repository.dart';
import 'package:swiss_ai/presentation/study/bloc/study_bloc.dart';
import 'package:swiss_ai/presentation/study/study_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements StudyRepository {}

void main() {
  group('StudyPage', () {
    late _MockRepository mockRepository;

    final cards = [
      Flashcard(
        id: '1',
        front: 'Front 1',
        back: 'Back 1',
        deckName: 'Flutter Basics',
        dueAt: DateTime(2026, 1, 1),
        repetitions: 0,
      ),
      Flashcard(
        id: '2',
        front: 'Front 2',
        back: 'Back 2',
        deckName: 'Flutter Basics',
        dueAt: DateTime(2026, 1, 1),
        repetitions: 0,
      ),
    ];

    setUp(() {
      mockRepository = _MockRepository();
      reset(mockRepository);
      when(() => mockRepository.getDeck(any())).thenAnswer((_) async => cards);
    });

    testWidgets('shows the front of the first card with progress', (tester) async {
      final bloc = StudyBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: StudyPage(bloc: bloc))),
      );
      await tester.pumpAndSettle();

      expect(find.text('Card 1 of 2'), findsOneWidget);
      expect(find.text('Front 1'), findsOneWidget);
      expect(find.byKey(const ValueKey('study_correct')), findsOneWidget);
      expect(find.byKey(const ValueKey('study_wrong')), findsOneWidget);
    });

    testWidgets('tapping the card flips to show the back', (tester) async {
      final bloc = StudyBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: StudyPage(bloc: bloc))),
      );
      await tester.pumpAndSettle();

      expect(find.text('Front 1'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('study_card')));
      await tester.pumpAndSettle();

      expect(find.text('Back 1'), findsOneWidget);
      expect(find.text('Front 1'), findsNothing);
    });

    testWidgets('tapping Correct answers and advances the card', (tester) async {
      when(() => mockRepository.answerCard(
            id: any(named: 'id'),
            correct: any(named: 'correct'),
          ))
          .thenAnswer((_) async => cards[0]);
      final bloc = StudyBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: StudyPage(bloc: bloc))),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('study_correct')));
      await tester.pumpAndSettle();

      expect(find.text('Card 2 of 2'), findsOneWidget);
      expect(find.text('Front 2'), findsOneWidget);
    });

    testWidgets('tapping Wrong answers and advances the card', (tester) async {
      when(() => mockRepository.answerCard(
            id: any(named: 'id'),
            correct: any(named: 'correct'),
          ))
          .thenAnswer((_) async => cards[0]);
      final bloc = StudyBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: StudyPage(bloc: bloc))),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('study_wrong')));
      await tester.pumpAndSettle();

      expect(find.text('Card 2 of 2'), findsOneWidget);
      expect(find.text('Front 2'), findsOneWidget);
    });
  });
}
