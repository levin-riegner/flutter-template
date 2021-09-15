import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/app/app.dart';
import 'package:logging_flutter/flogger.dart';

void mainShared() async {
  // Force Light Theme?
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Log Global Flutter Errors
  FlutterError.onError = (details) {
    Zone.current.handleUncaughtError(
        details.exception, details.stack ?? StackTrace.empty);
  };

  // Run Zoned App
  runZonedGuarded<Future<void>>(() async {
    runApp(App(isSessionAvailable: false));
  }, (Object error, StackTrace stackTrace) {
    // Catch and log crashes
    Flogger.e('Unhandled error', object: error, stackTrace: stackTrace);
    // Log stack trace separately (for better external visualization)
    Flogger.e("Stack trace: ${stackTrace.toString().replaceAll("\n", " ")}");
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  });
}
