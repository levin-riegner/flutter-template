import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lr_design_system/theme/theme.dart';

import 'app/app.dart';
import 'util/tools/flogger.dart';

void mainShared() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force Light Theme?
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
  );

  // Load Theme
  final jsonString = await rootBundle.loadString("assets/theme.json");
  ThemeProvider.setThemeFromJson(jsonString);

  // Run App
  runZonedGuarded<Future<void>>(() async {
    runApp(App(isSessionAvailable: false));
  }, (Object error, StackTrace stackTrace) {
    Flogger.error('Unhandled error', object: error, stackTrace: stackTrace);
  });
}