import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/models/article_model.dart';

class NewsDetailPage extends StatelessWidget {
  final Article article;

  const NewsDetailPage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String publishedDate = article.publishedAt != null
        ? DateFormat.yMMMMd('id_ID')
            .add_Hm()
            .format(article.publishedAt!.toLocal())
        : 'Tanggal tidak tersedia';

    return Scaffold(
      appBar: AppBar(
        title: Text(article.sourceName ?? 'Detail Berita'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title ?? 'Judul Tidak Tersedia',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Oleh: ${article.author ?? 'Penulis tidak diketahui'}',
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  publishedDate,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  article.urlToImage!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(Icons.broken_image,
                        color: Colors.grey[700], size: 50),
                  ),
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      width: double.infinity,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Text(
              article.description ?? 'Deskripsi tidak tersedia.',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 12),
            if (article.content != null &&
                article.content!.isNotEmpty &&
                article.content != article.description)
              Text(
                article.content!.length > 200
                    ? '${article.content!.substring(0, 200)}...'
                    : article.content!,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 15, height: 1.4),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
