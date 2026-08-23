import 'news_article.dart';

abstract class NewsRepository {
  Future<List<NewsArticle>> getNews();

  Future<List<NewsArticle>> getNewsByCategory(String category);

  Future<NewsArticle> getNewsById(int id);
}