import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:affirmup/data/models/models.dart';
import 'package:affirmup/presentation/widgets/affirmation_card.dart';

void main() {
  group('AffirmationCard', () {
    testWidgets('displays affirmation text', (tester) async {
      final affirmation = Affirmation(
        id: 'test_1',
        text: 'I am worthy of love',
        category: AffirmationCategory.selfLove,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AffirmationCard(affirmation: affirmation),
          ),
        ),
      );

      expect(find.text('I am worthy of love'), findsOneWidget);
    });

    testWidgets('displays category name', (tester) async {
      final affirmation = Affirmation(
        id: 'test_1',
        text: 'I am worthy',
        category: AffirmationCategory.selfLove,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AffirmationCard(affirmation: affirmation),
          ),
        ),
      );

      expect(find.text('Self Love'), findsOneWidget);
    });

    testWidgets('displays category icon', (tester) async {
      final affirmation = Affirmation(
        id: 'test_1',
        text: 'I am worthy',
        category: AffirmationCategory.selfLove,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AffirmationCard(affirmation: affirmation),
          ),
        ),
      );

      expect(find.text('💖'), findsOneWidget);
    });
  });
}
