import 'package:flutter_template/data/article/repository/article_data_repository.dart';
import 'package:flutter_template/data/article/service/local/article_db_service.dart';
import 'package:flutter_template/data/article/service/local/model/article_db_model.dart';
import 'package:flutter_template/data/article/service/remote/article_api_service.dart';
import 'package:flutter_template/data/article/service/remote/model/article_api_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class _MockDbService extends Mock implements ArticleDbService {}

class _MockApiService extends Mock implements ArticleApiService {}

void main() {
  group("Get Articles", () {
    final dbService = _MockDbService();
    final apiService = _MockApiService();
    final articleRepository = ArticleDataRepository(apiService, dbService);
    setUp(() {
      reset(dbService);
      reset(apiService);
      when(() => dbService.saveArticles(any()))
          .thenAnswer((_) => Future.value());
    });
    test("should return api articles when local articles is empty", () async {
      // Arrange
      const apiArticle = ArticleApiModel(title: "Bitcoin");
      when(() => dbService.getArticles(any())).thenAnswer((_) async => []);
      when(() => apiService.getArticles(any())).thenAnswer(
          (_) async => const ArticlesApiResponse(articles: [apiArticle]));
      // Act
      final articles = await articleRepository.getArticles("");
      // Assert
      assert(articles.length == 1);
      assert(articles[0].title == apiArticle.title);
    });
    test("should return local articles when local articles is not empty",
        () async {
      // Arrange
      final dbArticle = ArticleDbModel(title: "Bitcoin");
      when(() => dbService.getArticles(any()))
          .thenAnswer((_) async => [dbArticle]);
      // Act
      final articles = await articleRepository.getArticles("");
      // Assert
      assert(articles.length == 1);
      assert(articles[0].title == dbArticle.title);
    });
    test("should return api articles when force refresh is true", () async {
      // Arrange
      final dbArticle = ArticleDbModel(title: "Bitcoin");
      const apiArticle = ArticleApiModel(title: "Ethereum");
      when(() => dbService.getArticles(any()))
          .thenAnswer((_) async => [dbArticle]);
      when(() => apiService.getArticles(any())).thenAnswer(
          (_) async => const ArticlesApiResponse(articles: [apiArticle]));
      // Act
      final articles =
          await articleRepository.getArticles("", forceRefresh: true);
      // Assert
      assert(articles.length == 1);
      assert(articles[0].title == apiArticle.title);
    });
    test("should save to db when getting api articles", () async {
      // Arrange
      const apiArticle = ArticleApiModel(title: "Ethereum");
      when(() => dbService.getArticles(any())).thenAnswer((_) async => []);
      when(() => apiService.getArticles(any())).thenAnswer(
          (_) async => const ArticlesApiResponse(articles: [apiArticle]));
      // Act
      final articles = await articleRepository.getArticles("");
      // Assert
      verify(() => dbService.saveArticles(any(that: hasLength(1)))).called(1);
    });
  });
}
