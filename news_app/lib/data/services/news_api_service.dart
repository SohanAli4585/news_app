import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/article_model.dart';

class NewsApiService {
  Future<List<ArticleModel>> fetchNews(String category, {int page = 1}) async {
    final url = Uri.parse(
      "${ApiConstants.baseUrl}/top-headlines?country=us&category=$category&page=$page&pageSize=10&apiKey=${ApiConstants.apiKey}",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List articles = data["articles"];
      return articles.map((e) => ArticleModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load news");
    }
  }
}
