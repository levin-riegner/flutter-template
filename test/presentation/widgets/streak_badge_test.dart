import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:affirmup/presentation/widgets/streak_badge.dart';

void main() {
  group('StreakBadge', () {
    testWidgets('displays streak count', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StreakBadge(streak: 5),
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('shows "day" for streak 1', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StreakBadge(streak: 1),
          ),
        ),
      );

      expect(find.text('day'), findsOneWidget);
    });

    testWidgets('shows "days" for streak > 1', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StreakBadge(streak: 7),
          ),
        ),
      );

      expect(find.text('days'), findsOneWidget);
    });

    testWidgets('displays fire icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StreakBadge(streak: 3),
          ),
        ),
      );

      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
    });
  });
}
