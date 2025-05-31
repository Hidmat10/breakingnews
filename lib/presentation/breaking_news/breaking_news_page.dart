import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/news_provider.dart';
import '../home/widgets/news_list_item.dart';
import '../../core/utils/constants.dart';

class BreakingNewsPage extends StatefulWidget {
  const BreakingNewsPage({Key? key}) : super(key: key);

  @override
  State<BreakingNewsPage> createState() => _BreakingNewsPageState();
}

class _BreakingNewsPageState extends State<BreakingNewsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
      if (newsProvider.breakingNews.isEmpty &&
          newsProvider.breakingNewsState != NewsState.loading) {
        newsProvider.fetchBreakingNews();
      }
    });
  }

  Future<void> _refreshBreakingNews() async {
    await Provider.of<NewsProvider>(context, listen: false).fetchBreakingNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Berita Populer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat Ulang',
            onPressed: _refreshBreakingNews,
          ),
        ],
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          if (newsProvider.breakingNewsState == NewsState.loading &&
              newsProvider.breakingNews.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (newsProvider.breakingNewsState == NewsState.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        color: Theme.of(context).colorScheme.error, size: 50),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal memuat berita populer:',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      newsProvider.breakingNewsError.isNotEmpty
                          ? newsProvider.breakingNewsError
                          : kErrorDefault,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                      onPressed: _refreshBreakingNews,
                    ),
                  ],
                ),
              ),
            );
          } else if (newsProvider.breakingNews.isEmpty &&
              (newsProvider.breakingNewsState == NewsState.initial ||
                  newsProvider.breakingNewsState == NewsState.loaded)) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.newspaper_outlined,
                        color: Colors.grey, size: 50),
                    const SizedBox(height: 16),
                    Text(
                      'Tidak ada berita populer saat ini.',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Muat Ulang'),
                      onPressed: _refreshBreakingNews,
                    ),
                  ],
                ),
              ),
            );
          } else if (newsProvider.breakingNews.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: _refreshBreakingNews,
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                itemCount: newsProvider.breakingNews.length,
                itemBuilder: (context, index) {
                  final article = newsProvider.breakingNews[index];

                  return NewsListItem(article: article);
                },
              ),
            );
          }
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Silakan muat ulang untuk melihat berita.'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Muat Ulang'),
                  onPressed: _refreshBreakingNews,
                )
              ],
            ),
          ));
        },
      ),
    );
  }
}
