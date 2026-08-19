import 'package:swiss_ai/data/recording/model/recording.dart';
import 'package:swiss_ai/data/recording/repository/recording_repository.dart';
import 'package:swiss_ai/presentation/recording/bloc/recording_bloc.dart';
import 'package:swiss_ai/presentation/recording/recording_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements RecordingRepository {}

void main() {
  group('RecordingPage', () {
    late _MockRepository mockRepository;

    setUp(() {
      mockRepository = _MockRepository();
      reset(mockRepository);
    });

    testWidgets('renders the capture input and empty state', (tester) async {
      final bloc = RecordingBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: RecordingPage(bloc: bloc))),
      );

      expect(find.text('Meeting title (optional)...'), findsOneWidget);
      expect(find.byIcon(Icons.mic), findsOneWidget);
    });

    testWidgets('captures a recording and shows its title', (tester) async {
      when(() => mockRepository.capture(title: any(named: 'title'))).thenAnswer(
        (_) async => [
          Recording(
            id: '1',
            title: 'Sprint sync',
            transcript: 'Discussed the roadmap',
            capturedAt: DateTime(2026, 8, 12),
          ),
        ],
      );

      final bloc = RecordingBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: RecordingPage(bloc: bloc))),
      );

      await tester.enterText(find.byType(TextField), 'Sprint sync');
      await tester.tap(find.byIcon(Icons.mic));
      await tester.pumpAndSettle();

      expect(find.text('Sprint sync'), findsOneWidget);
      expect(find.text('Discussed the roadmap'), findsOneWidget);
    });
  });
}
