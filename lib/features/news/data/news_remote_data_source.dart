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

    return _parseList(response.data);
  }

  Future<List<NewsArticle>> getNewsByCategory(String category) async {
    final response = await _dio.get(
      '/rest/v1/news',
      queryParameters: {
        'select':
            'id,title,description,image_url,category,source,published_at',
        'category': 'eq.$category',
        'order': 'published_at.desc',
      },
    );

    return _parseList(response.data);
  }

  Future<NewsArticle> getNewsById(int id) async {
    final response = await _dio.get(
      '/rest/v1/news',
      queryParameters: {
        'select':
            'id,title,description,image_url,category,source,published_at',
        'id': 'eq.$id',
      },
    );

    final list = _parseList(response.data);

    if (list.isEmpty) {
      throw Exception('Article introuvable.');
    }

    return list.first;
  }

  List<NewsArticle> _parseList(dynamic data) {
    final list = data as List;

    return list
        .map(
          (item) => NewsArticle.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }
}