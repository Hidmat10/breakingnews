import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/utils/constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  void _signOut(BuildContext context) {
    print("Pengguna melakukan sign out...");
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.signIn,
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    const String userName = "Nama Pengguna Anda";
    const String userEmail = "email.anda@example.com";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        elevation: 0.5,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 12.0),
            child: Row(
              children: <Widget>[
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person_outline,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        userName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        userEmail,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: TextButton.icon(
              icon: Icon(Icons.edit_outlined,
                  size: 20, color: theme.colorScheme.primary),
              label: Text(
                'Edit Profil',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Fitur Edit Profil akan datang!')),
                );
                print('Tombol Edit Profil ditekan');
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          const Divider(height: 20, indent: 16, endIndent: 16),
          SwitchListTile(
            title: const Text('Mode Gelap'),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
            secondary: Icon(
              themeProvider.isDarkMode
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              color: theme.colorScheme.primary,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: Icon(Icons.exit_to_app_outlined,
                color: theme.colorScheme.error),
            title: Text(
              'Sign Out',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            onTap: () => _signOut(context),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
        ],
      ),
    );
  }
}
