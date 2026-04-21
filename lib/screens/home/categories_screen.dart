import 'package:flutter/material.dart';
import '../../services/product_service.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/skeleton_widget.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ProductService _productService = ProductService();
  late Stream<List<String>> _categoriesStream;

  @override
  void initState() {
    super.initState();
    _categoriesStream = _productService.getCategoriesStream();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: StreamBuilder<List<String>>(
          stream: _categoriesStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) => const SkeletonWidget.rectangular(height: 100),
                ),
              );
            }
            
            final categories = snapshot.data ?? [];
            if (categories.isEmpty) {
              return const Center(child: Text('No collections found'));
            }

            String getImage(String category) {
              final cat = category.toLowerCase();
              if (cat.contains('shoe') || cat.contains('sneaker') || cat.contains('chaussure')) {
                return 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=500&auto=format&fit=crop';
              } else if (cat.contains('shirt') || cat.contains('clothing') || cat.contains('vêtement') || cat.contains('vetement')) {
                return 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=500&auto=format&fit=crop';
              } else if (cat.contains('jean') || cat.contains('pant') || cat.contains('pantalon')) {
                return 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?q=80&w=500&auto=format&fit=crop';
              } else if (cat.contains('watch') || cat.contains('accessor') || cat.contains('accessoire')) {
                return 'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?q=80&w=500&auto=format&fit=crop';
              } else if (cat.contains('bag') || cat.contains('tote') || cat.contains('sac')) {
                return 'https://images.unsplash.com/photo-1584916201218-f4242ceb4809?q=80&w=500&auto=format&fit=crop';
              }
              // Fallback default images
              final List<String> defaultImages = [
                'https://images.unsplash.com/photo-1445205170230-053b83016050?q=80&w=1000&auto=format&fit=crop',
                'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=500&auto=format&fit=crop',
                'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=500&auto=format&fit=crop',
                'https://images.unsplash.com/photo-1541643600914-78b084683601?q=80&w=500&auto=format&fit=crop',
                'https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=500&auto=format&fit=crop', // replaced 404
              ];
              // Use hashcode to give a consistent random image per category
              return defaultImages[cat.hashCode.abs() % defaultImages.length];
            }

            return CustomScrollView(
              slivers: [
                // Search Bar and Title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2C2C2C) : AppTheme.lightGrey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            style: TextStyle(color: isDark ? Colors.white : Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Search our collections...',
                              prefixIcon: Icon(Icons.search, color: isDark ? Colors.white70 : Colors.grey),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              fillColor: Colors.transparent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Collections',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Curation of modern essentials',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white60 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // First large item
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: _buildCollectionCard(
                          title: categories[0],
                          subtitle: 'FEATURED',
                          imageUrl: getImage(categories[0]),
                          isLarge: true,
                        ),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                // Rest of categories in a responsive grid
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 350,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      mainAxisExtent: 200,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final catIndex = index + 1;
                        if (catIndex >= categories.length) return null;
                        return _buildCollectionCard(
                          title: categories[catIndex],
                          imageUrl: getImage(categories[catIndex]),
                        );
                      },
                      childCount: categories.length - 1,
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : AppTheme.lightGrey,
                        borderRadius: BorderRadius.circular(20),
                        border: isDark ? Border.all(color: Colors.white10) : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Limited Edition',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppTheme.accentGold : AppTheme.primaryBlue,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Handcrafted atelier pieces.',
                                style: TextStyle(color: isDark ? Colors.white60 : Colors.grey.shade600, fontSize: 13),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? AppTheme.accentGold : AppTheme.primaryBlue,
                              foregroundColor: isDark ? Colors.black : Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            child: const Text('VIEW ALL', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCollectionCard({
    required String title,
    String? subtitle,
    required String imageUrl,
    bool isLarge = false,
  }) {
    return Container(
      height: isLarge ? 300 : 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subtitle != null) ...[
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isLarge ? 28 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (isLarge)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
