class ArticleModel {
  final String? title;
  final String? description;
  final String? content; // 🔹 Added content
  final String? urlToImage;
  final String? source;
  final DateTime? publishedAt;

  ArticleModel({
    this.title,
    this.description,
    this.content,
    this.urlToImage,
    this.source,
    this.publishedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json['title'],
      description: json['description'],
      content: json['content'], // 🔹 Map API content
      urlToImage: json['urlToImage'],
      source: json['source']?['name'],
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
          : null,
    );
  }
}
