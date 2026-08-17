// Basic Flutter widget test for the SwissAI app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:swiss_ai/main.dart';

void main() {
  testWidgets('SwissAI app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ColorPickerApp());
    await tester.pumpAndSettle();

    // App bar and tabs are rendered.
    expect(find.text('Color Picker'), findsOneWidget);
    expect(find.text('RGB'), findsOneWidget);
    expect(find.text('CMYK'), findsOneWidget);
    expect(find.text('Palette'), findsOneWidget);

    // Switch to the CMYK tab and verify its panel renders.
    await tester.tap(find.text('CMYK'));
    await tester.pumpAndSettle();
    expect(find.byType(TabBarView), findsOneWidget);
  });
}
