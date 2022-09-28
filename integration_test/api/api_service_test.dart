import 'package:dio/dio.dart';
import 'package:flutter_template/app/config/constants.dart';
import 'package:flutter_template/app/config/environment.dart';
import 'package:flutter_template/data/article/service/remote/article_api_service.dart';
import 'package:flutter_template/data/shared/service/local/secure_storage.dart';
import 'package:flutter_template/data/shared/service/remote/network.dart';
import 'package:flutter_template/util/dependencies.dart';
import 'package:flutter_test/flutter_test.dart';

import '../integration_test_shared.dart';

/// Tests the remote api services with the API
void main() async {
  final binding = await initAppAndEnsureInitialized();
  late Dio httpClient;

  // Runs before each test
  setUp(() {
    final environment = getIt.get<Environment>();
    final secureStorage = SecureStorage();
    httpClient = Network.createHttpClient(
      environment.apiBaseUrl,
      Constants.apiKey,
      () => secureStorage.getUserAuthToken(),
      debugMode: true,
    );
  });

  // Runs after each test
  tearDown(() {
    httpClient.close();
  });

  group("Articles API Service", () {
    late ArticleApiService apiService;
    setUp(() {
      apiService = ArticleApiService(httpClient);
    });
    testWidgets('should return more than 0 articles for a valid query',
        (WidgetTester tester) async {
      final articles = await apiService.getArticles("flutter");
      assert(articles.articles!.isNotEmpty);
      assert(articles.totalResults! > 0);
    });
    testWidgets('should return 0 articles for an invalid query',
        (WidgetTester tester) async {
      const query = "noarticleswillmatchthisquerytextever";
      final articles = await apiService.getArticles(query);
      assert(articles.articles!.isEmpty);
      assert(articles.totalResults! == 0);
    });
  });
}
