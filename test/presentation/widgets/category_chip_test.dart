import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:affirmup/data/models/affirmation_category.dart';
import 'package:affirmup/presentation/widgets/category_chip.dart';

void main() {
  group('CategoryChip', () {
    testWidgets('displays category icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChip(
              category: AffirmationCategory.selfLove,
              isLocked: false,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('💖'), findsOneWidget);
    });

    testWidgets('displays category name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChip(
              category: AffirmationCategory.abundance,
              isLocked: false,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Abundance'), findsOneWidget);
    });

    testWidgets('shows lock icon when locked', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChip(
              category: AffirmationCategory.career,
              isLocked: true,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('no lock icon when unlocked', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChip(
              category: AffirmationCategory.selfLove,
              isLocked: false,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.lock), findsNothing);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChip(
              category: AffirmationCategory.selfLove,
              isLocked: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CategoryChip));
      expect(tapped, true);
    });
  });
}
