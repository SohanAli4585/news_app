import 'package:flutter/material.dart';
import '../../data/models/article_model.dart';
import '../../data/services/news_api_service.dart';

class NewsProvider extends ChangeNotifier {
  final NewsApiService _newsService = NewsApiService();

  List<ArticleModel> _articles = [];
  List<ArticleModel> get articles => _articles;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _page = 1;
  String _category = "general";
  bool _hasMore = true;

  /// 🔹 Fetch news safely after first frame
  Future<void> fetchNews({bool refresh = false, String? category}) async {
    if (_isLoading) return;

    if (category != null) {
      _category = category;
    }

    if (refresh) {
      _page = 1;
      _articles = [];
      _hasMore = true;
      // notifyListeners() will be called after first async await
    }

    if (!_hasMore) return;

    _isLoading = true;
    // 🔹 Notify listeners after a short delay to avoid during-build error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      final news = await _newsService.fetchNews(_category, page: _page);
      if (news.isEmpty) {
        _hasMore = false;
      } else {
        _articles.addAll(news);
        _page++;
      }
    } catch (e) {
      debugPrint("Error fetching news: $e");
    }

    _isLoading = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  /// Change category safely
  void changeCategory(String category) {
    fetchNews(refresh: true, category: category);
  }
}
