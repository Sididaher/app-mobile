import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/cart_service.dart';
import '../../core/theme/app_theme.dart';
import 'home_screen.dart';
import 'categories_screen.dart';
import 'wishlist_screen.dart';
import '../cart/cart_screen.dart';
import '../profile/profile_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  int _cartItemCount = 0;
  final AuthService _authService = AuthService();
  final CartService _cartService = CartService();

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const CategoriesScreen(),
      const WishlistScreen(),
      CartScreen(onReturnHome: () => setState(() => _currentIndex = 0)),
      const ProfileScreen(),
    ];
    _updateCartItemCount();
  }

  void _updateCartItemCount() async {
    final userId = _authService.getCurrentUserId();
    if (userId != null) {
      final count = await _cartService.getCartItemCount(userId);
      if (mounted) {
        setState(() => _cartItemCount = count);
      }
    }
  }

  void _onCartUpdated() {
    _updateCartItemCount();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.notes_rounded, color: isDark ? Colors.white : Colors.black87),
          onPressed: () {},
        ),
        title: Text(
          'A C H A T',
          style: TextStyle(
            color: isDark ? Colors.white : AppTheme.primaryBlue,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 8.0,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_bag_outlined, 
                    color: isDark ? Colors.white : Colors.black87, 
                    size: 26
                  ),
                  onPressed: () => setState(() => _currentIndex = 3),
                ),
                if (_cartItemCount > 0)
                  Positioned(
                    right: 6,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.accentGold : AppTheme.primaryBlue, 
                        shape: BoxShape.circle,
                        border: Border.all(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, width: 2),
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '$_cartItemCount',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 70,
          margin: const EdgeInsets.only(bottom: 24, left: 32, right: 32),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E).withOpacity(0.95) : Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.transparent : Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home_filled, Icons.home_outlined, 0),
              _buildNavItem(Icons.grid_view_rounded, Icons.grid_view_outlined, 1),
              _buildNavItem(Icons.favorite, Icons.favorite_border, 2),
              _buildNavItem(Icons.shopping_cart, Icons.shopping_cart_outlined, 3),
              _buildNavItem(Icons.person, Icons.person_outline, 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData activeIcon, IconData inactiveIcon, int index) {
    bool isSelected = _currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = index);
        if (index == 3) _updateCartItemCount();
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected 
              ? (isDark ? Colors.white.withOpacity(0.15) : AppTheme.primaryBlue.withOpacity(0.1)) 
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isSelected ? activeIcon : inactiveIcon, 
          size: isSelected ? 24 : 22,
          color: isSelected 
              ? (isDark ? Colors.white : AppTheme.primaryBlue)
              : (isDark ? Colors.white.withOpacity(0.3) : Colors.grey.shade400),
        ),
      ),
    );
  }
}
