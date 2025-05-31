import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:breakingnews/core/models/article_model.dart';

class NewsApiException implements Exception {
  final String message;
  NewsApiException(this.message);

  @override
  String toString() => message;
}

class NewsApiService {
  static const String _apiKey = 'd5e9a5096a934357b4e01155c607b9ad';
  static const String _baseUrl = 'newsapi.org';
  static const String _topHeadlinesPath = '/v2/top-headlines';
  static const String _everythingPath = '/v2/everything';
  Future<List<Article>> getTopHeadlines({String country = 'id'}) async {
    if (_apiKey == 'd5e9a5096a934357b4e01155c607b9ad' || _apiKey.isEmpty) {
      throw NewsApiException('API Key belum diatur di NewsApiService.');
    }

    final queryParameters = {
      'country': country,
      'apiKey': _apiKey,
      'pageSize': '20',
    };
    final uri = Uri.https(_baseUrl, _topHeadlinesPath, queryParameters);

    return _fetchNewsData(uri);
  }

  Future<List<Article>> getBreakingNewsOrSearch(
      {String? query, String sortBy = 'publishedAt'}) async {
    if (_apiKey == 'd5e9a5096a934357b4e01155c607b9ad' || _apiKey.isEmpty) {
      throw NewsApiException('API Key belum diatur di NewsApiService.');
    }

    final queryParameters = {
      'apiKey': _apiKey,
      'pageSize': '30',
      'sortBy': sortBy,
    };

    if (query != null && query.trim().isNotEmpty) {
      queryParameters['q'] = query.trim();
    } else {
      queryParameters['q'] = 'berita terkini';
    }

    final uri = Uri.https(_baseUrl, _everythingPath, queryParameters);
    return _fetchNewsData(uri);
  }

  Future<List<Article>> _fetchNewsData(Uri uri) async {
    try {
      if (kDebugMode) {
        print('NewsApiService: Requesting data from $uri');
      }
      final response = await http.get(uri).timeout(const Duration(seconds: 20));

      if (kDebugMode) {
        print('NewsApiService: Response status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'ok') {
          final List<dynamic> articlesJson = data['articles'] ?? [];
          return articlesJson
              .map((jsonItem) =>
                  Article.fromJson(jsonItem as Map<String, dynamic>))
              .toList();
        } else {
          final String apiErrorMessage = data['message'] ?? 'Unknown API error';
          final String apiErrorCode = data['code'] ?? 'N/A';
          if (kDebugMode) {
            print(
                'NewsApiService: API Error - Code: $apiErrorCode, Message: $apiErrorMessage');
          }
          throw NewsApiException('API Error ($apiErrorCode): $apiErrorMessage');
        }
      } else if (response.statusCode == 401) {
        throw NewsApiException('API Key tidak valid atau tidak diotorisasi.');
      } else if (response.statusCode == 429) {
        throw NewsApiException(
            'Terlalu banyak permintaan ke API. Coba lagi nanti.');
      } else {
        throw NewsApiException(
            'Gagal memuat berita: Status ${response.statusCode}');
      }
    } on NewsApiException {
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('NewsApiService: Exception - ${e.toString()}');
      }
      throw NewsApiException(
          'Terjadi kesalahan jaringan atau parsing data: ${e.toString()}');
    }
  }
}
