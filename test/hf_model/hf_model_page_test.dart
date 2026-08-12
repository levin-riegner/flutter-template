import 'package:color_picker/data/hf_model/model/hf_model.dart';
import 'package:color_picker/data/hf_model/repository/hf_model_repository.dart';
import 'package:color_picker/presentation/hf_model/bloc/hf_model_bloc.dart';
import 'package:color_picker/presentation/hf_model/hf_model_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements HfModelRepository {}

void main() {
  group('HfModelPage', () {
    late _MockRepository mockRepository;

    setUp(() {
      mockRepository = _MockRepository();
      reset(mockRepository);
    });

    testWidgets('renders the title and refresh button', (tester) async {
      final bloc = HfModelBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: HfModelPage(bloc: bloc))),
      );

      expect(find.text('Choose an on-device model'), findsOneWidget);
      expect(find.text('Refresh shortlist'), findsOneWidget);
      // No models yet.
      expect(find.text('No models yet — refresh to discover.'), findsOneWidget);
    });

    testWidgets('shows the shortlist after refresh', (tester) async {
      when(() => mockRepository.refreshShortlist()).thenAnswer(
        (_) async => [
          const HfModel(id: 'org/qwen2.5-1.5b', downloads: 10),
          const HfModel(id: 'org/gemma-2-2b', downloads: 8),
        ],
      );

      final bloc = HfModelBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: HfModelPage(bloc: bloc))),
      );

      await tester.tap(find.text('Refresh shortlist'));
      await tester.pumpAndSettle();

      expect(find.text('qwen2.5-1.5b'), findsOneWidget);
      expect(find.text('gemma-2-2b'), findsOneWidget);
    });
  });
}
