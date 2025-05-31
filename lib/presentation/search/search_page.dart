import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/news_provider.dart';
import '../../core/widgets/news_card.dart';
import 'dart:async'; // Untuk Debouncer

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    if (newsProvider.currentQuery.isNotEmpty) {
      _searchController.text = newsProvider.currentQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () {
      if (query.trim().isNotEmpty) {
        Provider.of<NewsProvider>(context, listen: false)
            .searchNews(query.trim());
      } else {
        Provider.of<NewsProvider>(context, listen: false).searchNews("");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Cari berita...',
            border: InputBorder.none,
            hintStyle: TextStyle(
                color: Theme.of(context)
                    .appBarTheme
                    .foregroundColor
                    ?.withOpacity(0.7)),
          ),
          style: TextStyle(
              color: Theme.of(context).appBarTheme.foregroundColor,
              fontSize: 18),
          onChanged: _onSearchChanged,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              Provider.of<NewsProvider>(context, listen: false).searchNews("");
            },
          )
        ],
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          if (newsProvider.searchState == NewsState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (newsProvider.searchState == NewsState.error) {
            return Center(
                child:
                    Text('Gagal mencari berita: ${newsProvider.searchError}'));
          } else if (newsProvider.searchResults.isEmpty &&
              newsProvider.currentQuery.isNotEmpty) {
            return Center(
                child: Text(
                    'Tidak ada hasil untuk "${newsProvider.currentQuery}".'));
          } else if (newsProvider.searchResults.isEmpty &&
              newsProvider.currentQuery.isEmpty) {
            return const Center(
                child: Text('Ketikkan kata kunci untuk mencari berita.'));
          }

          return ListView.builder(
            itemCount: newsProvider.searchResults.length,
            itemBuilder: (context, index) {
              final article = newsProvider.searchResults[index];
              return NewsCard(article: article);
            },
          );
        },
      ),
    );
  }
}
