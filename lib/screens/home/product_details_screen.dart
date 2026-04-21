import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../services/auth_service.dart';
import '../../services/cart_service.dart';
import '../../widgets/custom_button.dart';
import '../../core/utils/auth_guard.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  bool _isAddingToCart = false;
  final AuthService _authService = AuthService();
  final CartService _cartService = CartService();

  void _addToCart() async {
    // ✅ VÉRIFIER L'AUTHENTIFICATION
    if (!AuthGuard.isUserLoggedIn()) {
      if (mounted) {
        AuthGuard.showAuthRequiredDialog(context);
      }
      return;
    }

    final userId = _authService.getCurrentUserId();
    if (userId == null) return;

    setState(() => _isAddingToCart = true);

    try {
      await _cartService.addToCart(
        userId: userId,
        productId: widget.product.id,
        quantity: _quantity,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${widget.product.name} x $_quantity ajouté au panier',
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAddingToCart = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails Produit'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[200],
              child: Image.network(
                widget.product.imageUrl ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        widget.product.category,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Stock: ${widget.product.stock}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${widget.product.price.toStringAsFixed(2)} MRU',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Text(
                    'Quantité: ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                  ),
                  Text(
                    _quantity.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() => _quantity++),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomButton(
                label: 'Ajouter au Panier',
                icon: Icons.shopping_cart,
                isLoading: _isAddingToCart,
                onPressed: _addToCart,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
