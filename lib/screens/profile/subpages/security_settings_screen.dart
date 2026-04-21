import 'package:flutter/material.dart';
import '../../../widgets/settings_tile.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _biometrics = true;
  bool _twoStep = false;

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
          'SECURITY',
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
          SettingsTile(
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Last updated 3 months ago',
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.fingerprint_rounded,
            title: 'Biometric Login',
            subtitle: 'Use FaceID or Fingerprint',
            trailing: Switch(
              value: _biometrics,
              onChanged: (val) => setState(() => _biometrics = val),
            ),
          ),
          SettingsTile(
            icon: Icons.verified_user_outlined,
            title: 'Two-Step Verification',
            subtitle: 'Secure your account via SMS/Email',
            trailing: Switch(
              value: _twoStep,
              onChanged: (val) => setState(() => _twoStep = val),
            ),
          ),
          const SizedBox(height: 24),
          SettingsTile(
            icon: Icons.devices_other_rounded,
            title: 'Manage Devices',
            subtitle: '2 active sessions',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
