import 'package:flutter/material.dart';

const String kDefaultCountryCode = 'us';
const String kDefaultApiSortBy = 'publishedAt';

const String kErrorDefault = 'Terjadi kesalahan. Silakan coba lagi.';
const String kErrorNetwork =
    'Tidak ada koneksi internet atau server tidak terjangkau.';
const String kErrorTimeout = 'Koneksi timeout. Server terlalu lama merespons.';
const String kErrorParsing = 'Gagal memproses data dari server.';
const String kErrorNoData = 'Tidak ada data untuk ditampilkan.';

const Duration kDebounceDuration = Duration(milliseconds: 700);
const Duration kApiTimeoutDuration = Duration(seconds: 20);

const double kDefaultPadding = 16.0;
const double kDefaultMargin = 16.0;
const double kCardPadding = 12.0;
const double kCardMarginVertical = 8.0;
const double kCardMarginHorizontal = 12.0;

const double kFontSizeTitleLarge = 18.0;
const double kFontSizeBodyMedium = 14.0;
const double kFontSizeLabelSmall = 12.0;
const String kThemePreferenceKey = 'app_theme_preference_v1';

class AppRoutes {
  static const String home = '/';
  static const String breakingNews = '/breaking-news';
  static const String search = '/search';
  static const String newsDetail = '/news-detail';
  static const String settings = '/settings';
  static const String signIn = '/signIn';
  static const String signUp = '/signUp';
  static const String forgotPassword = '/forgotPassword';
}
