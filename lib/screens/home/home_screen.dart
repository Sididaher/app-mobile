import 'package:flutter/material.dart';
import '../../widgets/skeleton_widget.dart';
import '../../models/product_model.dart';
import '../../services/product_service.dart';
import '../../services/auth_service.dart';
import '../../services/cart_service.dart';
import '../../services/wishlist_service.dart';
import '../../widgets/product_card.dart';
import '../../core/utils/auth_guard.dart';
import '../../core/theme/app_theme.dart';
import 'product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  final AuthService _authService = AuthService();
  final CartService _cartService = CartService();
  final WishlistService _wishlistService = WishlistService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late Stream<List<ProductModel>> _productsStream;
  late Stream<List<String>> _categoriesStream;
  Stream<List<String>>? _wishlistStream;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _productsStream = _productService.getProductsStream();
    _categoriesStream = _productService.getCategoriesStream();
    
    final userId = _authService.getCurrentUserId();
    if (userId != null) {
      _wishlistStream = _wishlistService.getWishlistProductIds(userId);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  void _scrollToEssentials() {
    _scrollController.animateTo(
      600, // Position approximative de la section Essentials
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void _handleJoinCircle() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Merci d\'avoir rejoint l\'Appachat Circle !'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  void _toggleFavorite(String productId) async {
    if (!AuthGuard.isUserLoggedIn()) {
      AuthGuard.showAuthRequiredDialog(context);
      return;
    }

    final userId = _authService.getCurrentUserId();
    if (userId == null) return;

    try {
      final isAdded = await _wishlistService.toggleWishlist(
        userId: userId,
        productId: productId,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAdded ? 'Added to wishlist' : 'Removed from wishlist'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _addToCart(ProductModel product) async {
    if (!AuthGuard.isUserLoggedIn()) {
      AuthGuard.showAuthRequiredDialog(context);
      return;
    }

    final userId = _authService.getCurrentUserId();
    if (userId == null) return;

    try {
      await _cartService.addToCart(
        userId: userId,
        productId: product.id,
        quantity: 1,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} ajouté au panier'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Banner Section
          SliverToBoxAdapter(
            child: Container(
              height: 420,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1445205170230-053b83016050?q=80&w=1000&auto=format&fit=crop',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 48,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'NEW COLLECTION',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'THE ART OF\nMINIMALISM',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _scrollToEssentials,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text(
                        'DISCOVER NOW',
                        style: TextStyle(fontSize: 14, letterSpacing: 1.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.transparent : Colors.black.withOpacity(0.08),
                      blurRadius: 24,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Search objects of desire...',
                    prefixIcon: Icon(Icons.search, color: isDark ? Colors.white70 : Colors.grey),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Curation',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        'Selected by our atelier designers',
                        style: TextStyle(
                          color: isDark ? Colors.white60 : Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/catalog'),
                    child: Text(
                      'VIEW ALL',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppTheme.accentGold : Colors.brown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 140,
              child: StreamBuilder<List<String>>(
                stream: _categoriesStream,
                builder: (context, snapshot) {
                  final categories = ['All', ...(snapshot.data ?? [])];
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return _buildCategoryItem(categories[index]);
                    },
                  );
                },
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Essentials',
                    style: TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 2,
                    width: 40,
                    color: isDark ? AppTheme.accentGold : Colors.orange.shade300,
                  ),
                ],
              ),
            ),
          ),

          // Product Grid
          StreamBuilder<List<ProductModel>>(
            stream: _productsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const SkeletonWidget.rectangular(
                        height: 200,
                      ),
                      childCount: 6,
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {
                return const SliverFillRemaining(
                  child: Center(child: Text('Erreur de chargement')),
                );
              }
              final allProducts = snapshot.data ?? [];
              final products = _searchQuery.isEmpty 
                  ? allProducts 
                  : allProducts.where((p) => 
                      p.name.toLowerCase().contains(_searchQuery) || 
                      p.description.toLowerCase().contains(_searchQuery)
                    ).toList();

              if (products.isEmpty && _searchQuery.isNotEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('Aucun produit trouvé')),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = products[index];
                      return StreamBuilder<List<String>>(
                        stream: _wishlistStream,
                        initialData: const [],
                        builder: (context, favSnapshot) {
                          final favoriteIds = favSnapshot.data ?? [];
                          final isFavorite = favoriteIds.contains(product.id);
                          
                          return ProductCard(
                            product: product,
                            isFavorite: isFavorite,
                            onFavoriteToggle: () => _toggleFavorite(product.id),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailsScreen(
                                    product: product,
                                  ),
                                ),
                              );
                            },
                            onAddToCart: () => _addToCart(product),
                          );
                        },
                      );
                    },
                    childCount: products.length,
                  ),
                ),
              );
            },
          ),

          // Circle Section (Footer promo)
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(24),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/home/footer_promo.png'),
                    fit: BoxFit.cover,
                    opacity: 0.3,
                  ),
                ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'THE APPACHAT\nCIRCLE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Join our inner circle for early access to limited edition drops and private events.',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Email Address',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            hintStyle: const TextStyle(color: Colors.white54),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _handleJoinCircle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFE0B2),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: const Text('JOIN'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String category) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String imagePath;
    bool isAsset = true;

    final cat = category.toLowerCase();
    
    if (cat.contains('shoe') || cat.contains('sneaker') || cat.contains('chaussure')) {
      imagePath = 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=300&auto=format&fit=crop';
      isAsset = false;
    } else if (cat.contains('shirt') || cat.contains('clothing') || cat.contains('vêtement') || cat.contains('vetement')) {
      imagePath = 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=300&auto=format&fit=crop';
      isAsset = false;
    } else if (cat.contains('jean') || cat.contains('pant') || cat.contains('pantalon')) {
      imagePath = 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?q=80&w=300&auto=format&fit=crop';
      isAsset = false;
    } else if (cat.contains('watch') || cat.contains('accessor') || cat.contains('accessoire')) {
      imagePath = 'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?q=80&w=300&auto=format&fit=crop';
      isAsset = false;
    } else if (cat.contains('bag') || cat.contains('tote') || cat.contains('sac')) {
      imagePath = 'https://images.unsplash.com/photo-1584916201218-f4242ceb4809?q=80&w=300&auto=format&fit=crop';
      isAsset = false;
    } else if (cat == 'all' || cat == 'tous') {
      imagePath = 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?q=80&w=300&auto=format&fit=crop';
      isAsset = false;
    } else {
      imagePath = 'https://images.unsplash.com/photo-1445205170230-053b83016050?q=80&w=300&auto=format&fit=crop';
      isAsset = false;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.transparent : Colors.black.withOpacity(0.08),
                  blurRadius: 24,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipOval(
              child: isAsset
                  ? Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.category_outlined),
                    )
                  : Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.category_outlined),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: isDark ? Colors.white70 : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
