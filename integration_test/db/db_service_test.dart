import 'package:color_picker/data/article/service/local/article_db_service.dart';
import 'package:color_picker/data/article/service/local/model/article_db_model.dart';
import 'package:color_picker/data/shared/service/local/database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

import '../integration_test_shared.dart';

// Tests the local db services with Drift Database
void main() async {
  final binding = ensureInitialized();

  group("Articles DB Service", () {
    late AppDatabase db;
    late ArticleDbService dbService;
    // Runs before each test
    setUp(() async {
      final directory = await getApplicationDocumentsDirectory();
      db = AppDatabase.init(directory: directory.path);
      await db.delete(db.articles).go();
      dbService = ArticleDbService(db);
    });
    // Runs after each test
    tearDown(() async {
      await db.delete(db.articles).go();
      await db.close();
    });
    // Database
    testWidgets('should return all articles', (WidgetTester tester) async {
      await dbService.saveArticles([
        ArticlesCompanion.insert(
          title: const Value("Bitcoin"),
          description: const Value("Is a cryptocurrency"),
        ),
        ArticlesCompanion.insert(
          title: const Value("Ethereum"),
          description: const Value("Is a cryptocurrency"),
        ),
        ArticlesCompanion.insert(
          title: const Value("Litecoin"),
          description: const Value("Is a cryptocurrency"),
        ),
      ]);
      final articles = await dbService.getArticles(null);
      assert(articles.length == 3);
    });
    testWidgets('should return articles matching the query by title',
        (WidgetTester tester) async {
      await dbService.saveArticles([
        ArticlesCompanion.insert(
          title: const Value("Bitcoin"),
          description: const Value("Is a cryptocurrency"),
        ),
        ArticlesCompanion.insert(
          title: const Value("Ethereum"),
          description: const Value("Is a cryptocurrency"),
        ),
        ArticlesCompanion.insert(
          title: const Value("Litecoin"),
          description: const Value("Is a cryptocurrency"),
        ),
      ]);
      final articles = await dbService.getArticles("Bitcoin");
      assert(articles.length == 1);
      assert(articles.first.title!.contains("Bitcoin"));
    });
    testWidgets('should return articles matching the query by description',
        (WidgetTester tester) async {
      await dbService.saveArticles([
        ArticlesCompanion.insert(
          title: const Value("BTC"),
          description: const Value("Bitcoin is a cryptocurrency"),
        ),
        ArticlesCompanion.insert(
          title: const Value("ETH"),
          description: const Value("Is a cryptocurrency"),
        ),
        ArticlesCompanion.insert(
          title: const Value("LTC"),
          description: const Value("Litecoin is a cryptocurrency"),
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
        ArticlesCompanion.insert(
          title: const Value("BTC"),
          description: const Value("Bitcoin is a cryptocurrency"),
        ),
      ]);
      await dbService.saveArticles([
        ArticlesCompanion.insert(
          title: const Value("ETH"),
          description: const Value("Ethereum is a cryptocurrency"),
        ),
      ]);
    });
  });
}
