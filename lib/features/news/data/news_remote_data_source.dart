import 'package:dio/dio.dart';

import '../domain/news_article.dart';

class NewsRemoteDataSource {
  final Dio _dio;

  NewsRemoteDataSource(this._dio);

  Future<List<NewsArticle>> getNews() async {
    final response = await _dio.get(
      '/rest/v1/news',
      queryParameters: {
        'select':
            'id,title,description,image_url,category,source,published_at',
        'order': 'published_at.desc',
      },
    );

    final data = response.data as List;

    return data
        .map(
          (item) => NewsArticle.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }
}