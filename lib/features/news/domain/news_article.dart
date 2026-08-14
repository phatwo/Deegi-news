class NewsArticle {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;
  final String category;
  final String source;
  final DateTime publishedAt;

  const NewsArticle({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.category,
    required this.source,
    required this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String?,
      category: json['category'] as String,
      source: json['source'] as String,
      publishedAt: DateTime.parse(
        json['published_at'] as String,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'category': category,
      'source': source,
      'published_at': publishedAt.toIso8601String(),
    };
  }
}