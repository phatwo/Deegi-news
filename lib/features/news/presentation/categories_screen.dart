import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/news_article.dart';
import 'news_provider.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catégories'),
        centerTitle: true,
      ),
      body: newsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 56,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Impossible de charger les catégories.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(newsProvider);
                  },
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
        data: (articles) {
          final categories = _groupByCategory(articles);

          if (categories.isEmpty) {
            return const Center(
              child: Text('Aucune catégorie disponible.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            separatorBuilder: (_, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final category = categories.keys.elementAt(index);
              final categoryArticles = categories[category]!;

              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 26,
                    child: Icon(
                      _categoryIcon(category),
                    ),
                  ),
                  title: Text(
                    category,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${categoryArticles.length} '
                    '${categoryArticles.length > 1 ? 'articles' : 'article'}',
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryArticlesScreen(
                          category: category,
                          articles: categoryArticles,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Map<String, List<NewsArticle>> _groupByCategory(
    List<NewsArticle> articles,
  ) {
    final result = <String, List<NewsArticle>>{};

    for (final article in articles) {
      result.putIfAbsent(article.category, () => []).add(article);
    }

    return result;
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'technologie':
        return Icons.devices;
      case 'business':
        return Icons.business_center_outlined;
      case 'éducation':
        return Icons.school_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}

class CategoryArticlesScreen extends StatelessWidget {
  final String category;
  final List<NewsArticle> articles;

  const CategoryArticlesScreen({
    super.key,
    required this.category,
    required this.articles,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                article.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  article.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}