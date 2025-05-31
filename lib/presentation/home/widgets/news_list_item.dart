import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../../core/models/article_model.dart';
import '../../../core/utils/constants.dart';

class NewsListItem extends StatelessWidget {
  final Article article;
  const NewsListItem({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String publishedDateString;
    if (article.publishedAt != null) {
      try {
        final locale = Localizations.localeOf(context).toString();
        publishedDateString = DateFormat.yMMMMd(locale)
            .add_jm()
            .format(article.publishedAt!.toLocal());
      } catch (e) {
        publishedDateString = 'Format tanggal tidak valid';
        if (kDebugMode) {
          print(
              "Error formatting publishedAt date in NewsListItem for article '${article.title}': $e");
        }
      }
    } else {
      publishedDateString = 'Tanggal tidak tersedia';
    }

    final sourceText = article.sourceName?.isNotEmpty == true
        ? article.sourceName!
        : 'Sumber tidak diketahui';

    return InkWell(
      onTap: () {
        if (article.url.isNotEmpty) {
          Navigator.pushNamed(
            context,
            AppRoutes.newsDetail,
            arguments: article,
          );
        } else {
          if (kDebugMode) {
            print(
                "Gagal navigasi: URL artikel kosong untuk '${article.title}'.");
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Detail berita tidak dapat ditampilkan (URL tidak valid).')),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding / 1.5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.5,
                          height: 1.3,
                        ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    sourceText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.5,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    publishedDateString,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          color: Theme.of(context).hintColor,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
              const SizedBox(width: kDefaultPadding / 1.2),
            if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
              Expanded(
                flex: 2,
                child: Hero(
                  tag: 'newsImage_${article.url}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      article.urlToImage!,
                      height: 90,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 90,
                          width: double.infinity,
                          color:
                              Theme.of(context).highlightColor.withOpacity(0.1),
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                              strokeWidth: 2.0,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        if (kDebugMode) {
                          print(
                              "Error loading image in NewsListItem ${article.urlToImage}: $error");
                        }
                        return Container(
                          height: 90,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .highlightColor
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Icon(Icons.broken_image_outlined,
                              color: Theme.of(context).hintColor, size: 30),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
