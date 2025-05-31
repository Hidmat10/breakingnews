import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:breakingnews/core/providers/theme_provider.dart';
import 'package:breakingnews/core/providers/news_provider.dart';
import 'package:breakingnews/routes/app_routes.dart';
import 'package:breakingnews/core/utils/constants.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await initializeDateFormatting('${kDefaultCountryCode}_ID', null);
  } catch (e) {
    await initializeDateFormatting(null, null);
    if (kDebugMode) {
      print(
          "Peringatan di main.dart: Gagal menginisialisasi locale '${kDefaultCountryCode}_ID'. Menggunakan locale default. Error: $e");
    }
  }

  final themeProvider = await ThemeProvider.create();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Aplikasi Berita Flutter',
      theme: themeProvider.themeData,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
