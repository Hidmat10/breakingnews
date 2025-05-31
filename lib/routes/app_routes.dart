import 'package:flutter/material.dart';
import '../core/utils/constants.dart';
import '../presentation/auth/sign_in_page.dart';
import '../presentation/auth/sign_up_page.dart';
import '../presentation/auth/forgot_password_page.dart';
import '../presentation/main/main_screen.dart';
import '../presentation/breaking_news/breaking_news_page.dart';
import '../presentation/search/search_page.dart';
import '../presentation/settings/settings_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.signIn:
        return MaterialPageRoute(builder: (_) => const SignInPage());

      case AppRoutes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpPage());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const MainScreen());

      case AppRoutes.breakingNews:
        return MaterialPageRoute(builder: (_) => const BreakingNewsPage());

      case AppRoutes.search:
        return MaterialPageRoute(builder: (_) => const SearchPage());

      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());

      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text('Error Navigasi'),
              backgroundColor: Colors.teal,
            ),
            body: Center(
              child: Text(
                'Rute tidak ditemukan: ${settings.name}',
                style: const TextStyle(color: Colors.red, fontSize: 16.0),
              ),
            ),
          ),
        );
    }
  }
}
