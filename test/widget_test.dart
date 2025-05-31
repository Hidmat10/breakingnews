import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

// Sesuaikan nama proyek di baris impor berikut jika berbeda
import 'package:breakingnews/main.dart'; // Mengimpor MyApp
import 'package:breakingnews/presentation/main/main_screen.dart'; // Untuk verifikasi MainScreen
import 'package:breakingnews/core/providers/theme_provider.dart';
import 'package:breakingnews/core/providers/news_provider.dart';
// Import konstanta jika kDefaultCountryCode benar-benar digunakan dan ada.
// Jika tidak, Anda bisa menghapus impor ini dan menyesuaikan logika initializeDateFormatting.
import 'package:breakingnews/core/utils/constants.dart';

void main() {
  // Grup tes untuk keseluruhan aplikasi (MyApp)
  group('MyApp Widget Tests', () {
    late ThemeProvider mockThemeProvider;
    late NewsProvider mockNewsProvider;

    // setUpAll dijalankan sekali sebelum semua tes dalam grup ini
    setUpAll(() async {
      // Inisialisasi binding Flutter, penting untuk operasi async sebelum runApp
      WidgetsFlutterBinding.ensureInitialized();

      // Inisialisasi format tanggal, penting jika aplikasi Anda menggunakan intl
      try {
        // Coba inisialisasi dengan locale spesifik jika kDefaultCountryCode tersedia
        // Pastikan kDefaultCountryCode didefinisikan di core/utils/constants.dart
        // dan merupakan kode negara yang valid (misalnya 'id')
        await initializeDateFormatting('${kDefaultCountryCode}_ID', null);
      } catch (e) {
        // Fallback jika inisialisasi dengan locale spesifik gagal
        await initializeDateFormatting(null, null);
        print(
            "Peringatan di widget_test.dart: Gagal menginisialisasi locale '${kDefaultCountryCode}_ID'. Menggunakan locale default. Error: $e");
      }
    });

    // setUp dijalankan sebelum setiap tes individual
    setUp(() async {
      // Buat instance provider.
      // Pastikan metode `ThemeProvider.create()` ada dan berfungsi sebagaimana mestinya.
      // Jika ThemeProvider adalah ChangeNotifier biasa, cukup: mockThemeProvider = ThemeProvider();
      // dan muat preferensi tema jika perlu secara manual di sini untuk konsistensi tes.
      mockThemeProvider = await ThemeProvider.create();

      // Asumsi NewsProvider dapat diinisialisasi seperti ini untuk tes.
      // Jika NewsProvider memuat data di konstruktor atau initState,
      // Anda mungkin perlu state awal yang terkontrol atau mock untuk API calls.
      mockNewsProvider = NewsProvider();
    });

    testWidgets('App builds, shows initial structure, and correct theme',
        (WidgetTester tester) async {
      // Build aplikasi dengan MultiProvider seperti di main.dart
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: mockThemeProvider),
            ChangeNotifierProvider.value(value: mockNewsProvider),
          ],
          child: const MyApp(), // MyApp dari main.dart Anda
        ),
      );

      // Tunggu semua frame selesai (termasuk operasi async di init state)
      await tester.pumpAndSettle();

      // Verifikasi bahwa MaterialApp ada.
      expect(find.byType(MaterialApp), findsOneWidget,
          reason: "MaterialApp seharusnya ada dalam widget tree");

      // Verifikasi judul aplikasi dari MaterialApp.
      // Pastikan judul ini sesuai dengan yang ada di implementasi MyApp Anda.
      final MaterialApp materialApp =
          tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, 'Aplikasi Berita Flutter',
          reason: "Judul MaterialApp seharusnya 'Aplikasi Berita Flutter'");
      // Anda juga bisa memeriksa tema awal jika relevan
      // expect(materialApp.theme?.brightness, mockThemeProvider.currentTheme.brightness);

      // Verifikasi bahwa MainScreen (atau halaman awal Anda) ditampilkan.
      expect(find.byType(MainScreen), findsOneWidget,
          reason: "MainScreen seharusnya menjadi halaman awal yang tampil");

      // Verifikasi keberadaan BottomNavigationBar.
      expect(find.byType(BottomNavigationBar), findsOneWidget,
          reason: "BottomNavigationBar seharusnya ada di MainScreen");

      // Verifikasi label dan ikon tab awal ('Utama').
      expect(find.text('Utama'), findsOneWidget,
          reason: "Label 'Utama' seharusnya tampil");
      expect(find.byIcon(Icons.home), findsOneWidget,
          reason: "Ikon aktif 'home' seharusnya tampil untuk tab Utama");
      expect(find.byIcon(Icons.home_outlined), findsNothing,
          reason:
              "Ikon non-aktif 'home_outlined' seharusnya tidak tampil untuk tab Utama yang aktif");
    });

    testWidgets('BottomNavigationBar interaction and tab switching',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: mockThemeProvider),
            ChangeNotifierProvider.value(value: mockNewsProvider),
          ],
          child: const MyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // --- Kondisi Awal: Tab 'Utama' Aktif ---
      expect(find.text('Utama'), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget,
          reason: "Awal: Ikon aktif 'home' (Utama)");
      expect(find.byIcon(Icons.home_outlined), findsNothing);

      // Ikon untuk tab lain harus non-aktif
      expect(find.byIcon(Icons.flash_on_outlined), findsOneWidget,
          reason: "Awal: Ikon non-aktif 'flash_on_outlined' (Terkini)");
      expect(find.byIcon(Icons.flash_on), findsNothing);
      expect(find.byIcon(Icons.search_outlined), findsOneWidget,
          reason: "Awal: Ikon non-aktif 'search_outlined' (Cari)");
      expect(find.byIcon(Icons.search), findsNothing);

      // --- Tap item 'Terkini' ---
      await tester.tap(find.text('Terkini'));
      await tester.pumpAndSettle(); // Tunggu navigasi dan rebuild selesai

      // Verifikasi tab 'Terkini' sekarang aktif.
      expect(find.byIcon(Icons.flash_on), findsOneWidget,
          reason: "Setelah tap 'Terkini': Ikon aktif 'flash_on' (Terkini)");
      expect(find.byIcon(Icons.flash_on_outlined), findsNothing);

      // Verifikasi tab 'Utama' sekarang non-aktif.
      expect(find.byIcon(Icons.home_outlined), findsOneWidget,
          reason:
              "Setelah tap 'Terkini': Ikon non-aktif 'home_outlined' (Utama)");
      expect(find.byIcon(Icons.home), findsNothing);

      // Verifikasi tab 'Cari' masih non-aktif.
      expect(find.byIcon(Icons.search_outlined), findsOneWidget,
          reason:
              "Setelah tap 'Terkini': Ikon non-aktif 'search_outlined' (Cari)");
      expect(find.byIcon(Icons.search), findsNothing);

      // --- Tap item 'Cari' ---
      await tester.tap(find.text('Cari'));
      await tester.pumpAndSettle();

      // Verifikasi tab 'Cari' sekarang aktif.
      expect(find.byIcon(Icons.search), findsOneWidget,
          reason: "Setelah tap 'Cari': Ikon aktif 'search' (Cari)");
      expect(find.byIcon(Icons.search_outlined), findsNothing);

      // Verifikasi tab 'Terkini' sekarang non-aktif.
      expect(find.byIcon(Icons.flash_on_outlined), findsOneWidget,
          reason:
              "Setelah tap 'Cari': Ikon non-aktif 'flash_on_outlined' (Terkini)");
      expect(find.byIcon(Icons.flash_on), findsNothing);

      // Verifikasi tab 'Utama' masih non-aktif.
      expect(find.byIcon(Icons.home_outlined), findsOneWidget,
          reason: "Setelah tap 'Cari': Ikon non-aktif 'home_outlined' (Utama)");
      expect(find.byIcon(Icons.home), findsNothing);
    });
  });
}
