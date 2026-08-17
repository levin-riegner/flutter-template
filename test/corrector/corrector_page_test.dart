import 'package:swiss_ai/data/corrector/model/correction.dart';
import 'package:swiss_ai/data/corrector/repository/corrector_repository.dart';
import 'package:swiss_ai/presentation/corrector/bloc/corrector_bloc.dart';
import 'package:swiss_ai/presentation/corrector/corrector_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements CorrectorRepository {}

void main() {
  group('CorrectorPage', () {
    late _MockRepository mockRepository;

    setUp(() {
      mockRepository = _MockRepository();
      reset(mockRepository);
    });

    testWidgets('renders the input and Correct button', (tester) async {
      final bloc = CorrectorBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CorrectorPage(bloc: bloc))),
      );

      expect(find.byKey(const ValueKey('corrector_input')), findsOneWidget);
      expect(find.byKey(const ValueKey('corrector_correct')), findsOneWidget);
      expect(find.text('Correct'), findsOneWidget);
    });

    testWidgets('shows the corrected result after tapping Correct',
        (tester) async {
      when(() => mockRepository.correct(any())).thenAnswer(
        (_) async => Correction(
          original: "teh cat",
          corrected: "the cat",
          fixes: const [
            Fix(index: 0, replacement: "the", reason: "Fixed common typo"),
          ],
        ),
      );

      final bloc = CorrectorBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CorrectorPage(bloc: bloc))),
      );

      await tester.enterText(
        find.byKey(const ValueKey('corrector_input')),
        'teh cat',
      );
      await tester.tap(find.byKey(const ValueKey('corrector_correct')));
      await tester.pumpAndSettle();

      verify(() => mockRepository.correct('teh cat')).called(1);
      expect(find.text('the cat'), findsOneWidget);
    });

    testWidgets('does not correct blank input', (tester) async {
      final bloc = CorrectorBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CorrectorPage(bloc: bloc))),
      );

      await tester.enterText(
        find.byKey(const ValueKey('corrector_input')),
        '   ',
      );
      await tester.tap(find.byKey(const ValueKey('corrector_correct')));
      await tester.pumpAndSettle();

      verifyNever(() => mockRepository.correct(any()));
    });
  });
}
