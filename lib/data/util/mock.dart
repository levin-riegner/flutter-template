import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// Utility class for mocks
abstract class Mock {
  // Configure mock responses globally
  static const mockConfig = _MockConfig(
    ioDelay: Duration(seconds: 1),
    errorAllResponses: false,
    emptyResponses: false,
  );

  static const _basePath = "assets/mocks";

  static Future<Map<String, dynamic>> loadJsonFile(String name) async {
    final jsonString = await rootBundle.loadString("$_basePath/$name");
    return jsonDecode(jsonString);
  }
}

class _MockConfig {
  final Duration ioDelay;
  final bool errorAllResponses;
  final bool emptyResponses;

  const _MockConfig({
    required this.ioDelay,
    required this.errorAllResponses,
    required this.emptyResponses,
  });
}
