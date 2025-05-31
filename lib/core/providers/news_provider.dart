import 'package:flutter/foundation.dart';
import 'package:breakingnews/core/models/article_model.dart';
import 'package:breakingnews/core/api/news_api_service.dart';
import 'package:breakingnews/core/utils/constants.dart';

enum NewsState { initial, loading, loaded, error }

class NewsProvider with ChangeNotifier {
  final NewsApiService _newsApiService = NewsApiService();

  List<Article> _topHeadlines = [];
  NewsState _topHeadlinesState = NewsState.initial;
  String _topHeadlinesError = '';

  List<Article> get topHeadlines => _topHeadlines;
  NewsState get topHeadlinesState => _topHeadlinesState;
  String get topHeadlinesError => _topHeadlinesError;

  List<Article> _breakingNews = [];
  NewsState _breakingNewsState = NewsState.initial;
  String _breakingNewsError = '';

  List<Article> get breakingNews => _breakingNews;
  NewsState get breakingNewsState => _breakingNewsState;
  String get breakingNewsError => _breakingNewsError;

  List<Article> _searchResults = [];
  NewsState _searchState = NewsState.initial;
  String _searchError = '';
  String _currentQuery = '';

  List<Article> get searchResults => _searchResults;
  NewsState get searchState => _searchState;
  String get searchError => _searchError;
  String get currentQuery => _currentQuery;

  Future<void> fetchTopHeadlines({String country = kDefaultCountryCode}) async {
    _topHeadlinesState = NewsState.loading;
    _topHeadlinesError = '';
    notifyListeners();

    try {
      _topHeadlines = await _newsApiService.getTopHeadlines(country: country);

      _topHeadlinesState = NewsState.loaded;
      if (_topHeadlines.isEmpty && kDebugMode) {
        print(
            "NewsProvider (fetchTopHeadlines): Data berhasil dimuat namun kosong.");
      }
    } on NewsApiException catch (e) {
      _topHeadlinesError = e.message;
      _topHeadlinesState = NewsState.error;
      if (kDebugMode) {
        print(
            "Error di NewsProvider (fetchTopHeadlines - NewsApiException): ${e.message}");
      }
    } catch (e) {
      _topHeadlinesError = kErrorDefault;
      _topHeadlinesState = NewsState.error;
      if (kDebugMode) {
        print(
            "Error tidak terduga di NewsProvider (fetchTopHeadlines): $e, Tipe: ${e.runtimeType}");
      }
    }
    notifyListeners();
  }

  Future<void> fetchBreakingNews(
      {String? query, String sortBy = 'publishedAt'}) async {
    _breakingNewsState = NewsState.loading;
    _breakingNewsError = '';
    notifyListeners();

    try {
      _breakingNews = await _newsApiService.getBreakingNewsOrSearch(
          query: query, sortBy: sortBy);
      _breakingNewsState = NewsState.loaded;
      if (_breakingNews.isEmpty && kDebugMode) {
        print(
            "NewsProvider (fetchBreakingNews): Data berhasil dimuat namun kosong.");
      }
    } on NewsApiException catch (e) {
      _breakingNewsError = e.message;
      _breakingNewsState = NewsState.error;
      if (kDebugMode) {
        print(
            "Error di NewsProvider (fetchBreakingNews - NewsApiException): ${e.message}");
      }
    } catch (e) {
      _breakingNewsError = kErrorDefault;
      _breakingNewsState = NewsState.error;
      if (kDebugMode) {
        print(
            "Error tidak terduga di NewsProvider (fetchBreakingNews): $e, Tipe: ${e.runtimeType}");
      }
    }
    notifyListeners();
  }

  Future<void> searchNews(String query, {String sortBy = 'relevancy'}) async {
    _currentQuery = query.trim();

    if (_currentQuery.isEmpty) {
      _searchResults = [];
      _searchState = NewsState.initial;
      _searchError = '';
      notifyListeners();
      return;
    }

    _searchState = NewsState.loading;
    _searchError = '';
    notifyListeners();

    try {
      _searchResults = await _newsApiService.getBreakingNewsOrSearch(
          query: _currentQuery, sortBy: sortBy);
      _searchState = NewsState.loaded;
      if (_searchResults.isEmpty && kDebugMode) {
        print(
            "NewsProvider (searchNews): Data berhasil dimuat namun kosong untuk query '$_currentQuery'.");
      }
    } on NewsApiException catch (e) {
      _searchError = e.message;
      _searchState = NewsState.error;
      if (kDebugMode) {
        print(
            "Error di NewsProvider (searchNews - NewsApiException): ${e.message}");
      }
    } catch (e) {
      _searchError = kErrorDefault;
      _searchState = NewsState.error;
      if (kDebugMode) {
        print(
            "Error tidak terduga di NewsProvider (searchNews): $e, Tipe: ${e.runtimeType}");
      }
    }
    notifyListeners();
  }

  void clearSearchResults() {
    _searchResults = [];
    _searchState = NewsState.initial;
    _searchError = '';
    _currentQuery = '';
    notifyListeners();
  }
}
