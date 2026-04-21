import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/config/language_manager.dart';
import '../../../widgets/settings_tile.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
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
          'LANGUAGE',
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
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildLanguageTile('en', 'English', 'Standard US English'),
          _buildLanguageTile('fr', 'Français', 'Français de France'),
          _buildLanguageTile('ar', 'العربية', 'اللغة العربية الفصحى'),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(String code, String title, String subtitle) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = LanguageManager().currentLanguage == code;
    
    return SettingsTile(
      icon: Icons.translate,
      title: title,
      subtitle: subtitle,
      trailing: isSelected ? Icon(
        Icons.check_circle_rounded, 
        color: isDark ? AppTheme.accentGold : AppTheme.primaryBlue,
      ) : null,
      onTap: () {
        LanguageManager().setLanguage(code);
        setState(() {});
      },
    );
  }
}
