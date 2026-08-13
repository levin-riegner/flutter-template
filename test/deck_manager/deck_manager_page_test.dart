import 'package:color_picker/data/study/model/deck.dart';
import 'package:color_picker/data/study/repository/study_repository.dart';
import 'package:color_picker/presentation/deck_manager/bloc/deck_manager_bloc.dart';
import 'package:color_picker/presentation/deck_manager/deck_manager_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements StudyRepository {}

void main() {
  group('DeckManagerPage', () {
    late _MockRepository mockRepository;

    setUp(() {
      mockRepository = _MockRepository();
      reset(mockRepository);
    });

    testWidgets('lists decks with the create field', (tester) async {
      when(() => mockRepository.getDecks()).thenAnswer((_) async => [
        const Deck(name: 'Flutter Basics', newCount: 4, dueCount: 4),
      ]);
      when(() => mockRepository.getDeck(any())).thenAnswer((_) async => []);
      final bloc = DeckManagerBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: DeckManagerPage(bloc: bloc))),
      );
      await tester.pumpAndSettle();

      expect(find.text('Flutter Basics'), findsOneWidget);
      expect(find.byKey(const ValueKey('deck_name_input')), findsOneWidget);
      expect(find.byKey(const ValueKey('deck_create')), findsOneWidget);
    });

    testWidgets('opening a deck shows the add-card form', (tester) async {
      when(() => mockRepository.getDecks()).thenAnswer((_) async => [
        const Deck(name: 'Flutter Basics', newCount: 4, dueCount: 4),
      ]);
      when(() => mockRepository.getDeck(any())).thenAnswer((_) async => []);
      final bloc = DeckManagerBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: DeckManagerPage(bloc: bloc))),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Flutter Basics'));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('deck_front_input')), findsOneWidget);
      expect(find.byKey(const ValueKey('deck_back_input')), findsOneWidget);
      expect(find.byKey(const ValueKey('deck_add_card')), findsOneWidget);
    });
  });
}
