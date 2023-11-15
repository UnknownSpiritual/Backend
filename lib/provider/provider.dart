import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:uts_2/models/news.dart';

class NewsProvider with ChangeNotifier {
  List<Article> _newsList = [];

  List<Article> get newsList => _newsList;

  Future<void> fetchNews() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=e8db554e436b4414b448a3c853aba37b'));

    if (response.statusCode == 200) {
      final News responseData = newsFromJson(response.body);
      _newsList = responseData.articles.toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
