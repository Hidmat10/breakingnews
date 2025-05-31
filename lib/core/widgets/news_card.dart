import 'package:flutter/material.dart';
import '../models/article_model.dart'; // Pastikan path ini benar sesuai struktur folder Anda
import 'package:intl/intl.dart'; // Untuk format tanggal
import '../../presentation/news_detail/news_detail_page.dart'; // Pastikan path ini benar

class NewsCard extends StatelessWidget {
  final Article article;
  final bool isDense; // Untuk tampilan lebih ringkas jika diperlukan

  const NewsCard({Key? key, required this.article, this.isDense = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String timeAgo = article.publishedAt != null
        ? DateFormat.yMMMd('id_ID') // Menggunakan locale id_ID agar konsisten
            .add_jm()
            .format(article.publishedAt!.toLocal()) // Ditambahkan '!'
        : 'Tanggal tidak diketahui'; // Mengganti 'No date' dengan pesan lebih deskriptif

    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: isDense ? 8 : 16, vertical: isDense ? 4 : 8),
      child: InkWell(
        onTap: () {
          // Navigasi ke halaman detail berita
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailPage(article: article),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Penanganan article.urlToImage sudah baik dengan '!' di dalam if-check
              if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    article.urlToImage!, // Aman karena sudah dicek
                    height: isDense ? 120 : 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: isDense ? 120 : 180,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Icon(Icons.broken_image,
                            color: Colors.grey[600], size: 40),
                      );
                    },
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: isDense ? 120 : 180,
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
              if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
                SizedBox(height: isDense ? 8 : 12),
              Text(
                // Perbaikan untuk error "String?" can't be assigned to "String"
                // Berikan nilai default jika article.title null
                article.title ?? 'Judul Tidak Tersedia',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: isDense ? 16 : 18,
                    fontWeight: FontWeight.bold), // Sedikit ditebalkan
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isDense ? 4 : 8),
              Text(
                // Perbaikan untuk error "String?" can't be assigned to "String"
                // Berikan nilai default jika article.description null
                article.description ?? 'Deskripsi singkat tidak tersedia.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: isDense ? 12 : 14,
                    color: Colors.grey[700]), // Warna sedikit diubah
                maxLines: isDense ? 2 : 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isDense ? 6 : 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      // article.sourceName sudah ditangani dengan baik menggunakan '??'
                      article.sourceName ?? 'Sumber Tidak Diketahui',
                      style: TextStyle(
                        fontSize: isDense ? 10 : 12,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8), // Memberi sedikit jarak
                  Text(
                    timeAgo, // Ini sudah aman karena pasti String
                    style: TextStyle(
                        fontSize: isDense ? 10 : 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
