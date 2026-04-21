import 'package:flutter/material.dart';
import '../../../widgets/settings_tile.dart';
import '../../../core/theme/app_theme.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _orderUpdates = true;
  bool _promotionalOffers = false;

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
          'NOTIFICATIONS',
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
          _buildSwitchTile(
            'Push Notifications', 
            'Receive alerts on your device', 
            Icons.notifications_active_outlined, 
            _pushNotifications,
            (val) => setState(() => _pushNotifications = val),
          ),
          _buildSwitchTile(
            'Email Notifications', 
            'Get updates in your inbox', 
            Icons.mail_outline, 
            _emailNotifications,
            (val) => setState(() => _emailNotifications = val),
          ),
          const SizedBox(height: 24),
          const Text(
            'ACTIVITY UPDATES',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            'Order Status', 
            'Updates about your purchases', 
            Icons.local_shipping_outlined, 
            _orderUpdates,
            (val) => setState(() => _orderUpdates = val),
          ),
          _buildSwitchTile(
            'Promotional Offers', 
            'Discounts and seasonal sales', 
            Icons.sell_outlined, 
            _promotionalOffers,
            (val) => setState(() => _promotionalOffers = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon, bool value, ValueChanged<bool> onChanged) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SettingsTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: (isDark ? AppTheme.accentGold : AppTheme.primaryBlue).withValues(alpha: 0.3),
        activeColor: isDark ? AppTheme.accentGold : AppTheme.primaryBlue,
      ),
    );
  }
}
