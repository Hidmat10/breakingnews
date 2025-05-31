import 'package:flutter/foundation.dart';

class Article {
  final String? sourceId;
  final String? sourceName;
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? content;
  Article({
    this.sourceId,
    this.sourceName,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    String? tempSourceName;
    String? tempSourceId;

    if (json['source'] != null && json['source'] is Map<String, dynamic>) {
      final sourceMap = json['source'] as Map<String, dynamic>;
      tempSourceId = sourceMap['id'] as String?;
      tempSourceName = sourceMap['name'] as String?;
    } else if (json['source'] != null && json['source'] is String) {
      tempSourceName = json['source'] as String;
    }

    DateTime? parsedDate;
    if (json['publishedAt'] != null && json['publishedAt'] is String) {
      try {
        parsedDate = DateTime.tryParse(json['publishedAt'] as String);

        if (parsedDate == null && (json['publishedAt'] as String).isNotEmpty) {
          if (kDebugMode) {
            print(
                "Gagal parsing tanggal: ${json['publishedAt']}. Format mungkin tidak standar ISO 8601.");
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error parsing tanggal '${json['publishedAt']}': $e");
        }
      }
    }

    String? descriptionText = json['description'] as String?;
    String? contentText = json['content'] as String?;

    return Article(
      sourceId: tempSourceId,
      sourceName: tempSourceName ?? 'Sumber Tidak Diketahui',
      author: json['author'] as String?,
      title: json['title'] as String? ?? 'Judul Tidak Tersedia',
      description: descriptionText,
      url: json['url'] as String? ?? '',
      urlToImage: json['urlToImage'] as String?,
      publishedAt: parsedDate,
      content: contentText,
    );
  }

  void printDetails() {
    if (kDebugMode) {
      print("--- Detail Artikel ---");
      print("Judul: $title");
      print("Sumber: $sourceName (ID: $sourceId)");
      print("Penulis: $author");
      print("URL: $url");
      print("URL Gambar: $urlToImage");
      print("Tanggal Terbit: $publishedAt");
      print("Deskripsi: $description");
      print("----------------------");
    }
  }
}
