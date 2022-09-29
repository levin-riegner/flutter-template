import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_template/data/article/model/article.dart';
import 'package:flutter_template/data/article/repository/article_repository.dart';
import 'package:flutter_template/data/shared/model/error/data_error.dart';
import 'package:flutter_template/presentation/articles/bloc/articles_bloc.dart';
import 'package:flutter_template/presentation/articles/bloc/articles_error.dart';
import 'package:flutter_template/presentation/articles/bloc/articles_event.dart';
import 'package:flutter_template/presentation/articles/bloc/articles_state.dart';
import 'package:flutter_template/presentation/shared/util/data_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements ArticleRepository {}

void main() {
  group('ArticlesBloc', () {
    late _MockRepository mockRepository;
    setUp(() {
      mockRepository = _MockRepository();
      reset(mockRepository);
    });
    group("ArticlesEvent.fetch", () {
      const article1 = Article(
        id: "1",
        title: "Flutter",
        description: "Learn Flutter",
        imageUrl: null,
        url: null,
        publishedAt: null,
      );
      blocTest<ArticlesBloc, ArticlesState>(
        'should emit [loading, success] when articles are fetched successfully',
        setUp: () => when(() => mockRepository.getArticles(any()))
            .thenAnswer((_) async => [article1]),
        build: () => ArticlesBloc(mockRepository),
        act: (bloc) => bloc.add(const ArticlesEvent.fetch()),
        expect: () => [
          const ArticlesState.articlesList(data: DataState.loading()),
          const ArticlesState.articlesList(
              data: DataState.success(data: [article1])),
        ],
      );
      blocTest<ArticlesBloc, ArticlesState>(
        'should emit [loading, success] when articles are fetched successfully but are empty',
        setUp: () => when(() => mockRepository.getArticles(any()))
            .thenAnswer((_) async => []),
        build: () => ArticlesBloc(mockRepository),
        act: (bloc) => bloc.add(const ArticlesEvent.fetch()),
        expect: () => [
          const ArticlesState.articlesList(data: DataState.loading()),
          const ArticlesState.articlesList(data: DataState.success(data: [])),
        ],
      );
      final unknownException = Exception("Unknown");
      final unknownDataError = DataError.unknown(error: unknownException);
      const notFoundError = DataError.notFound();
      const apiError = DataError.apiError(reason: "Api error");
      const expiredError =
          DataError.apiError(reason: "your subscription has expired");
      blocTest<ArticlesBloc, ArticlesState>(
        'should emit [loading, failure(unknown)] when articles are not fetched successfully',
        setUp: () => when(() => mockRepository.getArticles(any()))
            .thenThrow(unknownException),
        build: () => ArticlesBloc(mockRepository),
        act: (bloc) => bloc.add(const ArticlesEvent.fetch()),
        skip: 1,
        expect: () => [
          ArticlesState.articlesList(
              data: DataState.failure(
                  reason: ArticlesError.unknown(reason: "$unknownException"))),
        ],
      );
      blocTest<ArticlesBloc, ArticlesState>(
        'should emit [loading, success] when articles are not found',
        setUp: () => when(() => mockRepository.getArticles(any()))
            .thenThrow(notFoundError),
        build: () => ArticlesBloc(mockRepository),
        act: (bloc) => bloc.add(const ArticlesEvent.fetch()),
        skip: 1,
        expect: () => [
          const ArticlesState.articlesList(data: DataState.success(data: [])),
        ],
      );
      blocTest<ArticlesBloc, ArticlesState>(
        'should emit [loading, failure(expired)] when articles are not fetched successfully',
        setUp: () => when(() => mockRepository.getArticles(any()))
            .thenThrow(expiredError),
        build: () => ArticlesBloc(mockRepository),
        act: (bloc) => bloc.add(const ArticlesEvent.fetch()),
        skip: 1,
        expect: () => [
          const ArticlesState.articlesList(
              data: DataState.failure(
                  reason: ArticlesError.subscriptionExpired())),
        ],
      );
      blocTest<ArticlesBloc, ArticlesState>(
        'should emit [loading, failure(apiError)] when articles are not fetched successfully',
        setUp: () =>
            when(() => mockRepository.getArticles(any())).thenThrow(apiError),
        build: () => ArticlesBloc(mockRepository),
        act: (bloc) => bloc.add(const ArticlesEvent.fetch()),
        skip: 1,
        expect: () => [
          const ArticlesState.articlesList(
              data: DataState.failure(
                  reason: ArticlesError.unknown(reason: "Api error"))),
        ],
      );
    });
  });
}
