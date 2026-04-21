import 'package:flutter/material.dart';
import '../../../widgets/settings_tile.dart';
import '../../../core/theme/app_theme.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

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
          'CONTACT US',
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
          const Text(
            'WE’RE HERE TO HELP',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
          ),
          const SizedBox(height: 24),
          SettingsTile(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'Live Chat',
            subtitle: 'Average response: 2 mins',
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.mail_outline_rounded,
            title: 'Email Support',
            subtitle: 'support@appachats.com',
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.phone_outlined,
            title: 'Phone Support',
            subtitle: '+222 123 456 78',
            onTap: () {},
          ),
          const SizedBox(height: 32),
          const Text(
            'SOCIALS',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialIcon(context, Icons.facebook, 'Facebook'),
              _buildSocialIcon(context, Icons.camera_alt_outlined, 'Instagram'),
              _buildSocialIcon(context, Icons.business_outlined, 'LinkedIn'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(BuildContext context, IconData icon, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            shape: BoxShape.circle,
            border: isDark ? Border.all(color: Colors.white10) : null,
          ),
          child: Icon(icon, color: isDark ? AppTheme.accentGold : AppTheme.primaryBlue),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}
