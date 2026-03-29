import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:affirmup/app/app.dart';
import 'package:affirmup/app/di.dart';
import 'package:affirmup/data/services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Register dependencies
  await Dependencies.register();

  // Increment session count for review prompt
  await getIt<ReviewPromptService>().incrementSession();

  runApp(const App());
}
