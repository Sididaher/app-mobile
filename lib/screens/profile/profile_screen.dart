import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_manager.dart';
import '../../widgets/skeleton_widget.dart';
import '../../widgets/loading_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  late Future<UserModel?> _userFuture;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _refreshUser();
  }

  void _refreshUser() {
    setState(() {
      _userFuture = _authService.getCurrentUser();
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    
    // Afficher une boîte de dialogue pour choisir entre Caméra et Galerie
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Prendre une photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choisir dans la galerie'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final XFile? image = await picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );

    if (image != null) {
      _uploadImage(File(image.path));
    }
  }

  Future<void> _uploadImage(File file) async {
    setState(() => _isUploading = true);
    try {
      await _authService.updateProfilePicture(file);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo de profil mise à jour !')),
        );
        _refreshUser();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'envoi : $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: FutureBuilder<UserModel?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(message: 'Chargement du profil...');
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return _buildGuestProfile();
          }

          final user = snapshot.data!;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  
                  // Profile Header
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _isUploading ? null : _pickImage,
                        behavior: HitTestBehavior.opaque,
                        child: Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF3F4F6),
                                border: Border.all(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, width: 4),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDark ? Colors.transparent : Colors.black.withOpacity(0.08),
                                    blurRadius: 24,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                                image: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(user.avatarUrl!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: _isUploading
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: SkeletonWidget.circular(size: 40),
                                      ),
                                    )
                                  : (user.avatarUrl == null || user.avatarUrl!.isEmpty
                                      ? Center(
                                          child: Icon(
                                            Icons.person,
                                            size: 50,
                                            color: isDark ? Colors.white24 : Colors.grey.shade400,
                                          ),
                                        )
                                      : null),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isDark ? AppTheme.accentGold : AppTheme.primaryBlue,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: isDark ? Colors.transparent : Colors.black.withOpacity(0.08),
                                      blurRadius: 24,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                  border: Border.all(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.fullName != null && user.fullName!.isNotEmpty 
                                  ? user.fullName! 
                                  : user.email.split('@')[0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 24, 
                                fontWeight: FontWeight.bold, 
                                color: isDark ? Colors.white : Colors.black,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Silver Tier Member',
                              style: TextStyle(fontSize: 14, color: isDark ? Colors.white60 : Colors.grey.shade600),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppTheme.accentGold.withOpacity(0.2) : const Color(0xFFFFE0B2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'EST. 2023',
                                    style: TextStyle(
                                      fontSize: 10, 
                                      fontWeight: FontWeight.bold, 
                                      letterSpacing: 1,
                                      color: isDark ? AppTheme.accentGold : Colors.black,
                                    ),
                                  ),
                                ),
                                if (user.isAdmin) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.red.shade300),
                                    ),
                                    child: const Text(
                                      'ADMIN',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red, letterSpacing: 1),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Stats Cards
                  Row(
                    children: [
                      _buildStatCard('12', 'ORDERS'),
                      const SizedBox(width: 20),
                      _buildStatCard('450', 'APPACHAT POINTS'),
                    ],
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Section: Account Essentials
                  _buildSectionTitle('ACCOUNT ESSENTIALS'),
                  const SizedBox(height: 16),
                  _buildMenuTile(
                    icon: Icons.inventory_2_outlined,
                    title: 'My Orders',
                    subtitle: 'Manage your recent purchases',
                    onTap: () => Navigator.pushNamed(context, '/orders'),
                  ),
                  _buildMenuTile(
                    icon: Icons.location_on_outlined,
                    title: 'Shipping Address',
                    subtitle: '2 saved locations',
                    onTap: () {},
                  ),
                  _buildMenuTile(
                    icon: Icons.credit_card_outlined,
                    title: 'Payment Methods',
                    subtitle: 'Visa ending in •••• 4242',
                    onTap: () {},
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Section: Preferences
                  _buildSectionTitle('PREFERENCES'),
                  const SizedBox(height: 16),
                  _buildMenuTile(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    subtitle: 'App & notification preferences',
                    onTap: () {},
                  ),
                  _buildThemeTile(),
                  _buildMenuTile(
                    icon: Icons.help_outline_rounded,
                    title: 'Help Center',
                    subtitle: '24/7 Concierge support',
                    onTap: () {},
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _showLogoutConfirmDialog,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: isDark ? Colors.red.withOpacity(0.3) : Colors.red.shade100),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: isDark ? Colors.red.withOpacity(0.05) : Colors.transparent,
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
        },
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.transparent : Colors.black.withOpacity(0.08), 
              blurRadius: 24, 
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
          border: Theme.of(context).brightness == Brightness.dark ? Border.all(color: Colors.white10) : null,
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold, 
                color: Theme.of(context).brightness == Brightness.dark ? AppTheme.accentGold : AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 1),
            ),
          ],
        ),
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

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: Colors.white10) : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: isDark ? AppTheme.accentGold : AppTheme.primaryBlue),
        ),
        title: Text(
          title, 
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
        ),
        subtitle: Text(
          subtitle, 
          style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey.shade500),
        ),
        trailing: Icon(Icons.chevron_right, size: 20, color: isDark ? Colors.white38 : Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildThemeTile() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: Colors.white10) : null,
      ),
      child: ListenableBuilder(
        listenable: ThemeManager(),
        builder: (context, _) {
          final isDark = ThemeManager().isDarkMode;
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: isDark ? AppTheme.accentGold : AppTheme.primaryBlue,
              ),
            ),
            title: Text(
              'Mode Sombre', 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
            ),
            subtitle: Text(
              isDark ? 'Activé' : 'Désactivé', 
              style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey.shade500),
            ),
            trailing: Switch(
              value: isDark,
              onChanged: (value) => ThemeManager().toggleTheme(value),
              activeColor: AppTheme.accentGold,
            ),
          );
        },
      ),
    );
  }

  Widget _buildGuestProfile() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_outline, size: 80, color: Colors.grey),
          const SizedBox(height: 24),
          const Text('Veuillez vous connecter pour voir votre profil', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            child: const Text('SE CONNECTER'),
          ),
        ],
      ),
    );
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
}
