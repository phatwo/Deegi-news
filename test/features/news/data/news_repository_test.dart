import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:deegi_news/features/news/data/news_local_data_source.dart';
import 'package:deegi_news/features/news/data/news_remote_data_source.dart';
import 'package:deegi_news/features/news/data/news_repository_impl.dart';
import 'package:deegi_news/features/news/domain/news_article.dart';

class MockNewsRemoteDataSource extends Mock
    implements NewsRemoteDataSource {}

class MockNewsLocalDataSource extends Mock
    implements NewsLocalDataSource {}

void main() {
  late MockNewsRemoteDataSource remoteDataSource;
  late MockNewsLocalDataSource localDataSource;
  late NewsRepositoryImpl repository;

  final article = NewsArticle(
    id: 1,
    title: 'Test article',
    description: 'Description test',
    imageUrl: 'https://example.com/image.jpg',
    category: 'Technologie',
    source: 'DeegiNews',
    publishedAt: DateTime(2026, 8, 14),
  );

  setUp(() {
    remoteDataSource = MockNewsRemoteDataSource();
    localDataSource = MockNewsLocalDataSource();

    repository = NewsRepositoryImpl(
      remoteDataSource,
      localDataSource,
    );
  });

  test(
    'retourne les données de l API quand la requête réussit',
    () async {
      when(() => remoteDataSource.getNews())
          .thenAnswer((_) async => [article]);

      when(() => localDataSource.saveNews([article]))
          .thenAnswer((_) async {});

      final result = await repository.getNews();

      expect(result, [article]);

      verify(() => remoteDataSource.getNews()).called(1);
      verify(() => localDataSource.saveNews([article])).called(1);
    },
  );

  test(
    'retourne le cache quand l API échoue',
    () async {
      when(() => remoteDataSource.getNews()).thenThrow(
        DioException(
          requestOptions: RequestOptions(
            path: '/rest/v1/news',
          ),
        ),
      );

      when(() => localDataSource.getCachedNews())
          .thenAnswer((_) async => [article]);

      final result = await repository.getNews();

      expect(result, [article]);

      verify(() => remoteDataSource.getNews()).called(1);
      verify(() => localDataSource.getCachedNews()).called(1);
    },
  );

  test(
    'remonte l erreur quand API et cache échouent',
    () async {
      final error = DioException(
        requestOptions: RequestOptions(
          path: '/rest/v1/news',
        ),
      );

      when(() => remoteDataSource.getNews())
          .thenThrow(error);

      when(() => localDataSource.getCachedNews())
          .thenAnswer((_) async => []);

      expect(
        () => repository.getNews(),
        throwsA(isA<DioException>()),
      );

      verify(() => remoteDataSource.getNews()).called(1);
      verify(() => localDataSource.getCachedNews()).called(1);
    },
  );

  test(
    'sauvegarde les articles après une récupération réussie',
    () async {
      when(() => remoteDataSource.getNews())
          .thenAnswer((_) async => [article]);

      when(() => localDataSource.saveNews([article]))
          .thenAnswer((_) async {});

      final result = await repository.getNews();

      expect(result.length, 1);
      expect(result.first.title, 'Test article');

      verify(() => remoteDataSource.getNews()).called(1);
      verify(() => localDataSource.saveNews([article])).called(1);
    },
  );
}