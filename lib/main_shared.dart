import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/app/app.dart';
import 'package:logging_flutter/logging_flutter.dart';

void mainShared({
  required Future<void> Function() registerDependencies,
}) async {
  // Run Zoned App
  runZonedGuarded<Future<void>>(() async {
    // Ensure WidgetsBinding is initialized
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    // Delay first frame to allow for dependencies initialization
    widgetsBinding.deferFirstFrame();
    // Log Global Flutter Errors
    FlutterError.onError = (details) {
      Zone.current.handleUncaughtError(
          details.exception, details.stack ?? StackTrace.empty);
    };
    // Enable only portrait mode
    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );
    // Register Dependencies
    await registerDependencies();
    // Run App
    runApp(const App());
    // Remove native launch screen and begin Flutter take over
    widgetsBinding.allowFirstFrame();
  }, (Object error, StackTrace stackTrace) {
    // Catch and log crashes
    Flogger.e("Unhandled error: $error", stackTrace: stackTrace);
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      // Log stack trace separately (for better external visualization)
      Flogger.e("Stack trace: ${stackTrace.toString().replaceAll("\n", " ")}");
    }
  });
}
