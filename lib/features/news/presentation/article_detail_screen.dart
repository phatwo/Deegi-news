import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'news_provider.dart';

class ArticleDetailScreen extends ConsumerWidget {
  final int articleId;

  const ArticleDetailScreen({
    super.key,
    required this.articleId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articleAsync = ref.watch(
      articleDetailProvider(articleId),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Article'),
      ),
      body: articleAsync.when(
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
                  'Impossible de charger cet article.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(
                      articleDetailProvider(articleId),
                    );
                  },
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
        data: (article) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (article.imageUrl != null &&
                    article.imageUrl!.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    height: 240,
                    child: Image.network(
                      article.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 60,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Chip(
                        label: Text(article.category),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        article.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          const Icon(
                            Icons.source_outlined,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(article.source),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        _formatDate(article.publishedAt),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall,
                      ),

                      const SizedBox(height: 24),

                      Text(
                        article.description,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                              height: 1.6,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();

    return '${localDate.day.toString().padLeft(2, '0')}/'
        '${localDate.month.toString().padLeft(2, '0')}/'
        '${localDate.year}';
  }
}