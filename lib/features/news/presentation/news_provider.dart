import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/network/network_providers.dart';
import '../data/news_local_data_source.dart';
import '../data/news_remote_data_source.dart';
import '../data/news_repository_impl.dart';
import '../domain/news_article.dart';
import '../domain/news_repository.dart';

final newsRemoteDataSourceProvider =
    Provider<NewsRemoteDataSource>((ref) {
  return NewsRemoteDataSource(
    ref.watch(dioProvider),
  );
});

final newsLocalDataSourceProvider =
    Provider<NewsLocalDataSource>((ref) {
  return NewsLocalDataSource(
    Hive.box<String>('news_cache'),
  );
});

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepositoryImpl(
    ref.watch(newsRemoteDataSourceProvider),
    ref.watch(newsLocalDataSourceProvider),
  );
});

final newsProvider = FutureProvider<List<NewsArticle>>((ref) async {
  return ref.watch(newsRepositoryProvider).getNews();
});

final categoryNewsProvider =
    FutureProvider.family<List<NewsArticle>, String>(
  (ref, category) {
    return ref
        .watch(newsRepositoryProvider)
        .getNewsByCategory(category);
  },
);

final articleDetailProvider =
    FutureProvider.family<NewsArticle, int>(
  (ref, id) {
    return ref
        .watch(newsRepositoryProvider)
        .getNewsById(id);
  },
);