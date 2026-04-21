import 'package:flutter/material.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../widgets/settings_tile.dart';

class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({super.key});

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'THEME MODE',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListenableBuilder(
        listenable: ThemeManager(),
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildThemeTile('Light', Icons.light_mode_outlined, !ThemeManager().isDarkMode),
              _buildThemeTile('Dark', Icons.dark_mode_outlined, ThemeManager().isDarkMode),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                child: Text(
                  'Auto-switching themes are coming soon to follow your system settings.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeTile(String title, IconData icon, bool isSelected) {
    return SettingsTile(
      icon: icon,
      title: title,
      trailing: Transform.scale(
        scale: 0.8,
        child: Radio<bool>(
          value: true,
          groupValue: isSelected,
          onChanged: (val) {
            if (title == 'Dark') {
              ThemeManager().toggleTheme(true);
            } else {
              ThemeManager().toggleTheme(false);
            }
          },
        ),
      ),
      onTap: () {
        if (title == 'Dark') {
          ThemeManager().toggleTheme(true);
        } else {
          ThemeManager().toggleTheme(false);
        }
      },
    );
  }
}
