import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/config/language_manager.dart';
import '../../services/auth_service.dart';
import '../../widgets/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();

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
        title: Text(
          'SETTINGS',
          style: TextStyle(
            color: isDark ? Colors.white : AppTheme.primaryBlue,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // General
            _buildSectionTitle('GENERAL'),
            const SizedBox(height: 16),
            SettingsTile(
              icon: Icons.language,
              title: 'Language',
              subtitle: LanguageManager().getLanguageName(LanguageManager().currentLanguage),
              onTap: () => Navigator.pushNamed(context, '/settings/language'),
            ),
            SettingsTile(
              icon: Icons.palette_outlined,
              title: 'Theme Mode',
              subtitle: 'Light, Dark or System',
              onTap: () => Navigator.pushNamed(context, '/settings/theme'),
            ),
            SettingsTile(
              icon: Icons.notifications_none_outlined,
              title: 'Notifications',
              subtitle: 'Push & Email preferences',
              onTap: () => Navigator.pushNamed(context, '/settings/notifications'),
            ),
            SettingsTile(
              icon: Icons.tune,
              title: 'App Preferences',
              subtitle: 'Tailor your experience',
              onTap: () {},
            ),
            
            const SizedBox(height: 32),

            // Account
            _buildSectionTitle('ACCOUNT'),
            const SizedBox(height: 16),
            SettingsTile(
              icon: Icons.person_outline,
              title: 'Profile Information',
              subtitle: 'Name, email & avatar',
              onTap: () {},
            ),
            SettingsTile(
              icon: Icons.location_on_outlined,
              title: 'Shipping Address',
              subtitle: 'Manage delivery locations',
              onTap: () => Navigator.pushNamed(context, '/settings/address'),
            ),
            SettingsTile(
              icon: Icons.credit_card_outlined,
              title: 'Payment Methods',
              subtitle: 'Added cards & preferred ways to pay',
              onTap: () => Navigator.pushNamed(context, '/settings/payment'),
            ),
            SettingsTile(
              icon: Icons.security,
              title: 'Security',
              subtitle: 'Password, Biometrics & 2FA',
              onTap: () => Navigator.pushNamed(context, '/settings/security'),
            ),
            
            const SizedBox(height: 32),

            // Support
            _buildSectionTitle('SUPPORT'),
            const SizedBox(height: 16),
            SettingsTile(
              icon: Icons.help_outline_rounded,
              title: 'Help Center',
              subtitle: 'FAQ & concierge support',
              onTap: () => Navigator.pushNamed(context, '/settings/help'),
            ),
            SettingsTile(
              icon: Icons.mail_outline,
              title: 'Contact Us',
              subtitle: 'Reach our team directly',
              onTap: () => Navigator.pushNamed(context, '/settings/contact'),
            ),
            SettingsTile(
              icon: Icons.info_outline,
              title: 'About AppAchats',
              subtitle: 'Our story and mission',
              onTap: () => Navigator.pushNamed(context, '/settings/about'),
            ),
            SettingsTile(
              icon: Icons.gavel_outlined,
              title: 'Terms & Conditions',
              subtitle: 'Legal agreements',
              onTap: () => Navigator.pushNamed(context, '/settings/terms'),
            ),
            SettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'How we handle your data',
              onTap: () => Navigator.pushNamed(context, '/settings/privacy'),
            ),

            const SizedBox(height: 32),

            // Extra
            _buildSectionTitle('EXTRA'),
            const SizedBox(height: 16),
            _buildExtraTile(
              title: 'Version Info',
              trailing: Text('v1.0.0 (Build 42)', style: TextStyle(color: isDark ? Colors.white38 : Colors.grey.shade500, fontSize: 12)),
            ),
            _buildExtraTile(
              title: 'Clear Cache',
              trailing: Icon(Icons.cleaning_services_outlined, size: 18, color: isDark ? Colors.white38 : Colors.grey.shade400),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache cleared')));
              },
            ),
            _buildExtraTile(
              title: 'Delete Account',
              trailing: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
              titleColor: Colors.red,
              onTap: () {},
            ),

            const SizedBox(height: 48),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _showLogoutConfirmDialog,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: isDark ? Colors.red.withValues(alpha: 0.3) : Colors.red.shade100),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: isDark ? Colors.red.withValues(alpha: 0.05) : Colors.transparent,
                ),
                child: const Text(
                  'LOG OUT',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _handleLogout() async {
    try {
      await _authService.logout();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la déconnexion : $e')),
        );
      }
    }
  }

  void _showLogoutConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleLogout();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12, 
          fontWeight: FontWeight.bold, 
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white38 : Colors.grey.shade500, 
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildExtraTile({
    required String title,
    required Widget trailing,
    Color? titleColor,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        title: Text(
          title, 
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: titleColor ?? (isDark ? Colors.white70 : Colors.black87)),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
