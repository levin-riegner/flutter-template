import 'package:flutter_template/data/article/service/local/article_db_service.dart';
import 'package:flutter_template/data/article/service/local/model/article_db_model.dart';
import 'package:flutter_template/data/shared/service/local/database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../integration_test_shared.dart';

/// Tests the local db services with the Hive Database
void main() async {
  final binding = ensureInitialized();
  await Hive.initFlutter();

  group("Articles DB Service", () {
    late Box<ArticleDbModel> box;
    late ArticleDbService dbService;
    // Runs before each test
    setUp(() async {
      Hive.registerAdapter<ArticleDbModel>(ArticleDbModelAdapter());
      box = await Hive.openBox<ArticleDbModel>(Database.articleBox);
      await box.clear();
      dbService = ArticleDbService(box);
    });
    // Runs after each test
    tearDown(() async {
      await box.clear();
      Hive.resetAdapters();
    });
    // Database
    testWidgets('should return all articles', (WidgetTester tester) async {
      await dbService.saveArticles([
        ArticleDbModel(
          title: "Bitcoin",
          description: "Is a cryptocurrency",
        ),
        ArticleDbModel(
          title: "Ethereum",
          description: "Is a cryptocurrency",
        ),
        ArticleDbModel(
          title: "Litecoin",
          description: "Is a cryptocurrency",
        ),
      ]);
      final articles = await dbService.getArticles(null);
      assert(articles.length == 3);
    });
    testWidgets('should return articles matching the query by title',
        (WidgetTester tester) async {
      await dbService.saveArticles([
        ArticleDbModel(
          title: "Bitcoin",
          description: "Is a cryptocurrency",
        ),
        ArticleDbModel(
          title: "Ethereum",
          description: "Is a cryptocurrency",
        ),
        ArticleDbModel(
          title: "Litecoin",
          description: "Is a cryptocurrency",
        ),
      ]);
      final articles = await dbService.getArticles("Bitcoin");
      assert(articles.length == 1);
      assert(articles.first.title!.contains("Bitcoin"));
    });
    testWidgets('should return articles matching the query by description',
        (WidgetTester tester) async {
      await dbService.saveArticles([
        ArticleDbModel(
          title: "BTC",
          description: "Bitcoin is a cryptocurrency",
        ),
        ArticleDbModel(
          title: "ETH",
          description: "Is a cryptocurrency",
        ),
        ArticleDbModel(
          title: "LTC",
          description: "Litecoin is a cryptocurrency",
        ),
      ]);
      final articles = await dbService.getArticles("Bitcoin");
      assert(articles.length == 1);
      assert(articles.first.description!.contains("Bitcoin"));
    });
    testWidgets('should emit all articles when new articles are saved',
        (WidgetTester tester) async {
      timeout(seconds: 2);
      final articlesStream = dbService.articles();
      final article1 = ArticleDbModel(
          title: "BTC", description: "Bitcoin is a cryptocurrency");
      final article2 = ArticleDbModel(
          title: "ETH", description: "Ethereum is a cryptocurrency");
      expectLater(
          articlesStream,
          emitsInOrder(
            [
              [],
              [article1],
              [article1, article2],
            ],
          ));
      await dbService.saveArticles([article1]);
      await dbService.saveArticles([article2]);
    });
  });
}
