import 'package:color_picker/data/personas/model/persona.dart';
import 'package:color_picker/data/personas/repository/personas_repository.dart';
import 'package:color_picker/presentation/personas/bloc/personas_bloc.dart';
import 'package:color_picker/presentation/personas/personas_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements PersonalitiesRepository {}

void main() {
  group('PersonalitiesPage', () {
    late _MockRepository mockRepository;

    setUp(() {
      mockRepository = _MockRepository();
      reset(mockRepository);
    });

    testWidgets('renders the list of personas', (tester) async {
      when(() => mockRepository.getAll()).thenAnswer((_) async => const [
        Persona(
          id: 'expert',
          name: 'Expert',
          description: 'Deep answers',
          systemPrompt: 'Be an expert.',
          iconName: 'science',
        ),
        Persona(
          id: 'teacher',
          name: 'Teacher',
          description: 'Tutor',
          systemPrompt: 'Teach clearly.',
          iconName: 'school',
        ),
      ]);

      final bloc = PersonalitiesBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: PersonalitiesPage(bloc: bloc))),
      );
      await tester.pumpAndSettle();

      expect(find.text('Expert'), findsOneWidget);
      expect(find.text('Teacher'), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_unchecked), findsNWidgets(2));
    });

    testWidgets('selecting a persona shows the check icon', (tester) async {
      when(() => mockRepository.getAll()).thenAnswer((_) async => const [
        Persona(
          id: 'expert',
          name: 'Expert',
          description: 'Deep answers',
          systemPrompt: 'Be an expert.',
          iconName: 'science',
        ),
      ]);

      final bloc = PersonalitiesBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: PersonalitiesPage(bloc: bloc))),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Expert'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_unchecked), findsNothing);
    });
  });
}
