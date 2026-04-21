import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header and Intro
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'GALERIE SÉLECTIONNÉE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Color(0xFFC4A484),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Articles Sauvegardés',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '6 articles dans votre atelier',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white60 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Featured Saved Item (Large Horizontal Card)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: _buildFeaturedSavedItem(),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Responsive Grid of small items
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                delegate: SliverChildListDelegate([
                  _buildSmallSavedItem(
                    title: 'Sac Fourre-tout',
                    category: 'SACS',
                    price: '420 MRU',
                    imageUrl: 'https://images.unsplash.com/photo-1584916201218-f4242ceb4809?q=80&w=500&auto=format&fit=crop',
                  ),
                  _buildSmallSavedItem(
                    title: 'Montre Linéaire',
                    category: 'MONTRES',
                    price: '1,200 MRU',
                    imageUrl: 'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?q=80&w=500&auto=format&fit=crop',
                  ),
                ]),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // Style Concierge CTA
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: _buildStyleConcierge(),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // More responsive grid items
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                delegate: SliverChildListDelegate([
                  _buildSmallSavedItem(
                    title: 'Baskets Blanches',
                    category: 'CHAUSSURES',
                    price: '185 MRU',
                    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=500&auto=format&fit=crop',
                  ),
                  _buildSmallSavedItem(
                    title: 'T-shirt Essentiel',
                    category: 'VÊTEMENTS',
                    price: '650 MRU',
                    imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=500&auto=format&fit=crop',
                  ),
                ]),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedSavedItem() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.transparent : Colors.black.withOpacity(0.08),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
        border: isDark ? Border.all(color: Colors.white10) : null,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              'https://images.unsplash.com/photo-1544022613-e87ca75a784a?q=80&w=500&auto=format&fit=crop',
              width: 120,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VÊTEMENTS EXTÉRIEURS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manteau en Laine Sculpté',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '890 MRU',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppTheme.accentGold : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppTheme.accentGold : AppTheme.primaryBlue,
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('AJOUTER', style: TextStyle(fontSize: 10)),
                    ),
                    const Spacer(),
                    Icon(Icons.favorite, color: isDark ? AppTheme.accentGold : Colors.black54, size: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallSavedItem({
    required String title,
    required String category,
    required String price,
    required String imageUrl,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.transparent : Colors.black.withOpacity(0.08),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
        border: isDark ? Border.all(color: Colors.white10) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            category,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            price,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? AppTheme.accentGold : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleConcierge() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : AppTheme.lightGrey,
        borderRadius: BorderRadius.circular(24),
        border: isDark ? Border.all(color: Colors.white10) : null,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, color: AppTheme.primaryBlue, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            'Concierge de Style',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Nous avons trouvé 3 articles qui se marient parfaitement avec votre Manteau en Laine.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white60 : Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {},
            child: Text(
              'VOIR LES SUGGESTIONS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: isDark ? AppTheme.accentGold : AppTheme.primaryBlue,
                decoration: TextDecoration.underline,
                decorationColor: isDark ? AppTheme.accentGold.withOpacity(0.5) : const Color(0xFFFFE0B2),
                decorationThickness: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
