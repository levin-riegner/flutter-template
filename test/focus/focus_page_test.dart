import 'package:color_picker/data/focus/model/focus_session.dart';
import 'package:color_picker/data/focus/repository/focus_repository.dart';
import 'package:color_picker/presentation/focus/bloc/focus_bloc.dart';
import 'package:color_picker/presentation/focus/focus_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements FocusRepository {}

void main() {
  group('FocusPage', () {
    late _MockRepository mockRepository;

    setUp(() {
      mockRepository = _MockRepository();
      reset(mockRepository);
    });

    testWidgets('shows the empty state when there are no sessions',
        (tester) async {
      when(() => mockRepository.getSessions()).thenAnswer((_) async => []);
      final bloc = FocusBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: FocusPage(bloc: bloc))),
      );
      await tester.pumpAndSettle();

      expect(find.text('No sessions yet. Add one to start focusing.'),
          findsOneWidget);
      expect(find.byKey(const ValueKey('focus_input')), findsOneWidget);
      expect(find.byKey(const ValueKey('focus_add')), findsOneWidget);
    });

    testWidgets('lists a session with its start button', (tester) async {
      when(() => mockRepository.getSessions()).thenAnswer((_) async => [
        const FocusSession(
            id: '1',
            label: 'Deep work',
            durationSeconds: 60,
            elapsedSeconds: 10,
            isRunning: false),
      ]);
      final bloc = FocusBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: FocusPage(bloc: bloc))),
      );
      await tester.pumpAndSettle();

      expect(find.text('Deep work'), findsOneWidget);
      expect(find.byKey(const ValueKey('focus_start_1')), findsOneWidget);
      expect(find.byKey(const ValueKey('focus_time_1')), findsOneWidget);
    });
  });
}
