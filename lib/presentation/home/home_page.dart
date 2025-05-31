import 'package:flutter/material.dart';
import '../../core/utils/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Berita Utama'),
        elevation: 0.5,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.grid_view_outlined),
            tooltip: 'Ubah Tampilan',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Fitur ubah tampilan akan datang!')),
              );
              print('Ikon Grid (Ubah Tampilan) ditekan');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Pengaturan',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
        ],
      ),
      body: _buildNewsList(context),
    );
  }

  Widget _buildNewsList(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Daftar berita akan muncul di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              '(Integrasikan dengan NewsProvider Anda)',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
