import 'package:flutter/services.dart' show rootBundle;

abstract class Mock {
  static Future<String> getArticlesResponse() =>
      _loadJsonFile("articles_response.json");

  static const _basePath = "assets/mocks";
  static Future<String> _loadJsonFile(String name) {
    return rootBundle.loadString("$_basePath/$name");
  }
}
