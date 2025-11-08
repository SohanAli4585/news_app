import 'package:flutter/material.dart';
import '../../data/models/article_model.dart';
import 'package:intl/intl.dart';

class NewsDetailPage extends StatelessWidget {
  final ArticleModel article;

  const NewsDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final date = article.publishedAt != null
        ? DateFormat.yMMMMd().format(article.publishedAt!)
        : "";

    return Scaffold(
      appBar: AppBar(title: Text(article.source ?? "News Detail")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            article.urlToImage != null
                ? Image.network(
                    article.urlToImage!,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 50),
                  ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article.title ?? "No Title",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Date & Source
                  Row(
                    children: [
                      Text(date, style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(width: 16),
                      if (article.source != null)
                        Text(
                          article.source!,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Content / Description
                  Text(
                    article.content ?? article.description ?? "No content",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
