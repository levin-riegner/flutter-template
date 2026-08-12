import 'package:color_picker/data/image_gen/model/generated_image.dart';
import 'package:color_picker/data/image_gen/repository/image_gen_repository.dart';
import 'package:color_picker/presentation/image_gen/bloc/image_gen_bloc.dart';
import 'package:color_picker/presentation/image_gen/image_gen_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements ImageGenRepository {}

void main() {
  group('ImageGenPage', () {
    late _MockRepository mockRepository;

    setUp(() {
      mockRepository = _MockRepository();
      reset(mockRepository);
    });

    testWidgets('renders the prompt input and empty state', (tester) async {
      final bloc = ImageGenBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ImageGenPage(bloc: bloc))),
      );

      expect(find.text('Describe an image to generate...'), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    });

    testWidgets('generates an image and shows the prompt card', (tester) async {
      when(() => mockRepository.generate(any())).thenAnswer(
        (_) async => [
          const GeneratedImage(id: '1', prompt: 'A mountain lake', url: null),
        ],
      );

      final bloc = ImageGenBloc(mockRepository);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ImageGenPage(bloc: bloc))),
      );

      await tester.enterText(find.byType(TextField), 'A mountain lake');
      await tester.tap(find.byIcon(Icons.auto_awesome));
      await tester.pumpAndSettle();

      expect(find.text('A mountain lake'), findsOneWidget);
    });
  });
}
