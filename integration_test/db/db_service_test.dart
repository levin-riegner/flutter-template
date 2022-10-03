import 'package:flutter_template/data/article/service/local/article_db_service.dart';
import 'package:flutter_template/data/article/service/local/model/article_db_model.dart';
import 'package:flutter_template/data/shared/service/local/database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import '../integration_test_shared.dart';

/// Tests the local db services with the Isar Database
void main() async {
  final binding = ensureInitialized();

  group("Articles DB Service", () {
    late Isar isar;
    late IsarCollection<ArticleDbModel> collection;
    late ArticleDbService dbService;
    // Runs before each test
    setUp(() async {
      isar = await Database.init();
      collection = isar.articleDbModels;
      await isar.writeTxn(() async => await collection.clear());
      dbService = ArticleDbService(collection);
    });
    // Runs after each test
    tearDown(() async {
      await isar.writeTxn(() async => await collection.clear());
      await isar.close();
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
