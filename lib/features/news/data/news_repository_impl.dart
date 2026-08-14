import 'package:dio/dio.dart';

import '../domain/news_article.dart';
import '../domain/news_repository.dart';
import 'news_local_data_source.dart';
import 'news_remote_data_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource _remoteDataSource;
  final NewsLocalDataSource _localDataSource;

  NewsRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<List<NewsArticle>> getNews() async {
    try {
      final articles = await _remoteDataSource.getNews();

      await _localDataSource.saveNews(articles);

      return articles;
    } on DioException {
      final cachedArticles = await _localDataSource.getCachedNews();

      if (cachedArticles.isNotEmpty) {
        return cachedArticles;
      }

      rethrow;
    } catch (_) {
      final cachedArticles = await _localDataSource.getCachedNews();

      if (cachedArticles.isNotEmpty) {
        return cachedArticles;
      }

      rethrow;
    }
  }
}