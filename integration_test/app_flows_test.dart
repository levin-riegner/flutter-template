import 'package:color_picker/app/app.dart';
import 'package:color_picker/presentation/shared/adaptive_theme/adaptive_theme_cubit.dart';
import 'package:color_picker/presentation/shared/adaptive_theme/adaptive_theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'integration_test_shared.dart';

/// End-to-end flows through the real routed [App].
///
/// Boots the full widget tree exactly as the shipped binary does, then drives
/// complex multi-screen flows: cross-tab bottom navigation, waiting for async
/// loading states in every on-device AI feature, the settings -> account
/// details stack, and the adaptive theme (brightness/color) change.
///
/// NOTE: These are authored for `flutter drive --driver=test_driver/
/// integration_test.dart --target=integration_test/app_flows_test.dart` and
/// are NOT auto-run during `flutter test` (they need a host device).
void main() async {
  await initAppAndEnsureInitialized();

  group('App bootstrap & bottom navigation', () {
    testWidgets('boots to Articles branch and shows all five tabs',
        (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // App bar title of the shell.
      expect(find.text('Flutter Template'), findsOneWidget);
      // Bottom navigation labels.
      for (final label in ['Articles', 'Blank', 'Chat', 'Image Gen', 'Record', 'Models']) {
        expect(find.text(label), findsAtLeastNWidgets(1));
      }
    });

    testWidgets('switches every bottom-nav tab without crashing',
        (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      for (final label in ['Chat', 'Image Gen', 'Record', 'Models', 'Blank', 'Articles']) {
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
      }
      // Back on the Articles branch after the round trip.
      expect(find.text('Articles'), findsAtLeastNWidgets(1));
    });
  });

  group('Chat flow (async loading)', () {
    testWidgets('sending a message waits for loading then shows the bubble',
        (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chat'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const ValueKey('chat_input')), 'hello');
      await tester.tap(find.byKey(const ValueKey('chat_send')));
      // Runs async send emission; spinner + success bubble settle.
      await tester.pumpAndSettle();
      expect(find.text('hello'), findsOneWidget);
    });
  });

  group('Image Gen flow (async loading)', () {
    testWidgets('generating waits for loading then shows the prompt card',
        (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Image Gen'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('image_gen_input')),
        'A mountain lake',
      );
      await tester.tap(find.byKey(const ValueKey('image_gen_generate')));
      await tester.pumpAndSettle();
      expect(find.text('A mountain lake'), findsOneWidget);
    });
  });

  group('Recording flow (async loading)', () {
    testWidgets('capturing waits for loading then shows the recording title',
        (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Record'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const ValueKey('recording_input')),
        'Sprint sync',
      );
      await tester.tap(find.byKey(const ValueKey('recording_capture')));
      await tester.pumpAndSettle();
      expect(find.text('Sprint sync'), findsOneWidget);
    });
  });

  group('Settings & navigation stack', () {
    testWidgets('opens Settings then navigates to Account Details',
        (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);

      await tester.tap(find.text('Account Details'));
      await tester.pumpAndSettle();
      expect(find.text('Account Details'), findsOneWidget);
    });
  });

  group('Adaptive theme (brightness) change', () {
    testWidgets('cubit flips dark <-> light theme state', (tester) async {
      final cubit = AdaptiveThemeCubit();
      expect(cubit.state, AdaptiveThemeState.dark);

      cubit.setLightTheme();
      expect(cubit.state, AdaptiveThemeState.light);

      cubit.setDarkTheme();
      expect(cubit.state, AdaptiveThemeState.dark);
    });
  });
}
