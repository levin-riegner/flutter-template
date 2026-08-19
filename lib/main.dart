import 'package:flutter/material.dart';
import 'package:swiss_ai/presentation/color_picker/color_picker_page.dart';

void main() {
  runApp(const ColorPickerApp());
}

class ColorPickerApp extends StatelessWidget {
  const ColorPickerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwissAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const ColorPickerPage(),
    );
  }
}
