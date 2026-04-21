import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../core/theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback? onAddToCart;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final double? width;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.onAddToCart,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.width,
  });

  String _getFallbackImage() {
    // Fournit une image Unsplash de qualité basée sur la catégorie si l'URL est cassée
    switch (product.category.toLowerCase()) {
      case 'vêtements':
      case 'clothing':
        return 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=500&auto=format&fit=crop';
      case 'chaussures':
      case 'shoes':
        return 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=500&auto=format&fit=crop';
      case 'accessoires':
      case 'accessories':
        return 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=500&auto=format&fit=crop';
      default:
        return 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=500&auto=format&fit=crop';
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget cardChild = Container(
        width: width,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.08),
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
            // Image Section (Utilisation de Flexible pour éviter l'overflow)
            Flexible(
              flex: 6,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      color: isDark ? const Color(0xFF2C2C2C) : AppTheme.lightGrey,
                      child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                          ? Image.network(
                              product.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.network(_getFallbackImage(), fit: BoxFit.cover),
                            )
                          : Image.network(_getFallbackImage(), fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onFavoriteToggle,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: isDark ? Colors.black38 : Colors.white.withOpacity(0.8),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: isFavorite ? Colors.red : (isDark ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Info Section
            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.category.toUpperCase(),
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            color: isDark ? Colors.white38 : Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${product.price.toStringAsFixed(2)} MRU',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppTheme.accentGold : AppTheme.primaryBlue,
                          ),
                        ),
                        GestureDetector(
                          onTap: onAddToCart,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? AppTheme.accentGold.withOpacity(0.1) : AppTheme.primaryBlue.withOpacity(0.1),
                            ),
                            child: Icon(
                              Icons.add_shopping_cart,
                              size: 12,
                              color: isDark ? AppTheme.accentGold : AppTheme.primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

    return GestureDetector(
      onTap: onTap,
      child: width != null ? Align(alignment: Alignment.center, child: cardChild) : cardChild,
    );
  }
}
