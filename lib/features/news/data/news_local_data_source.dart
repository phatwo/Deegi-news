import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../domain/news_article.dart';

class NewsLocalDataSource {
  final Box<String> _box;

  NewsLocalDataSource(this._box);

  Future<void> saveNews(List<NewsArticle> articles) async {
    final jsonData = articles
        .map((article) => article.toJson())
        .toList();

    await _box.put(
      'articles',
      jsonEncode(jsonData),
    );
  }

  Future<List<NewsArticle>> getCachedNews() async {
    final cachedData = _box.get('articles');

    if (cachedData == null || cachedData.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(cachedData) as List;

    return decoded
        .map(
          (item) => NewsArticle.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  bool get hasCache {
    final cachedData = _box.get('articles');
    return cachedData != null && cachedData.isNotEmpty;
  }
}