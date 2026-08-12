import 'package:color_picker/data/article/service/local/article_db_service.dart';
import 'package:color_picker/data/article/service/local/model/article_db_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../integration_test_shared.dart';

// Tests the local article DB service (pure-Dart in-memory store since the
// drift/isar layer was removed).
void main() async {
  ensureInitialized();

  group("Articles DB Service", () {
    late ArticleDbService dbService;
    setUp(() async {
      dbService = ArticleDbService();
    });

    testWidgets('should return all articles', (WidgetTester tester) async {
      await dbService.saveArticles([
        ArticleDbModel(
            id: '1',
            title: "Bitcoin",
            description: "Is a cryptocurrency",
            imageUrl: null,
            url: null,
            publishedAt: null),
        ArticleDbModel(
            id: '2',
            title: "Ethereum",
            description: "Is a cryptocurrency",
            imageUrl: null,
            url: null,
            publishedAt: null),
        ArticleDbModel(
            id: '3',
            title: "Litecoin",
            description: "Is a cryptocurrency",
            imageUrl: null,
            url: null,
            publishedAt: null),
      ]);
      final articles = await dbService.getArticles(null);
      assert(articles.length == 3);
    });

    testWidgets('should return articles matching the query by title',
        (WidgetTester tester) async {
      await dbService.saveArticles([
        ArticleDbModel(
            id: '1',
            title: "Bitcoin",
            description: "Is a cryptocurrency",
            imageUrl: null,
            url: null,
            publishedAt: null),
        ArticleDbModel(
            id: '2',
            title: "Ethereum",
            description: "Is a cryptocurrency",
            imageUrl: null,
            url: null,
            publishedAt: null),
        ArticleDbModel(
            id: '3',
            title: "Litecoin",
            description: "Is a cryptocurrency",
            imageUrl: null,
            url: null,
            publishedAt: null),
      ]);
      final articles = await dbService.getArticles("Bitcoin");
      assert(articles.length == 1);
      assert(articles.first.title!.contains("Bitcoin"));
    });

    testWidgets('should return articles matching the query by description',
        (WidgetTester tester) async {
      await dbService.saveArticles([
        ArticleDbModel(
            id: '1',
            title: "BTC",
            description: "Bitcoin is a cryptocurrency",
            imageUrl: null,
            url: null,
            publishedAt: null),
        ArticleDbModel(
            id: '2',
            title: "ETH",
            description: "Is a cryptocurrency",
            imageUrl: null,
            url: null,
            publishedAt: null),
        ArticleDbModel(
            id: '3',
            title: "LTC",
            description: "Litecoin is a cryptocurrency",
            imageUrl: null,
            url: null,
            publishedAt: null),
      ]);
      final articles = await dbService.getArticles("Bitcoin");
      assert(articles.length == 1);
      assert(articles.first.description!.contains("Bitcoin"));
    });

    testWidgets('should emit all articles when new articles are saved',
        (WidgetTester tester) async {
      timeout(seconds: 2);
      final articlesStream = dbService.articles();
      expectLater(
          articlesStream,
          emitsInOrder(
            [
              [],
              hasLength(1),
              hasLength(2),
            ],
          ));
      await dbService.saveArticles([
        ArticleDbModel(
            id: '1',
            title: "BTC",
            description: "Bitcoin is a cryptocurrency",
            imageUrl: null,
            url: null,
            publishedAt: null),
      ]);
      await dbService.saveArticles([
        ArticleDbModel(
            id: '2',
            title: "ETH",
            description: "Ethereum is a cryptocurrency",
            imageUrl: null,
            url: null,
            publishedAt: null),
      ]);
    });
  });
}
