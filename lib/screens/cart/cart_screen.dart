import 'package:flutter/material.dart';
import '../../models/cart_item_model.dart';
import '../../services/cart_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/cart_item_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart' as custom_error;
import '../../widgets/custom_button.dart';
import '../../core/utils/auth_guard.dart';
import '../../core/theme/app_theme.dart';


class CartScreen extends StatefulWidget {
  final VoidCallback? onReturnHome;
  const CartScreen({super.key, this.onReturnHome});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  final AuthService _authService = AuthService();

  late String _userId;
  late Future<List<CartItemModel>> _cartItemsFuture;

  @override
  void initState() {
    super.initState();
    
    _userId = _authService.getCurrentUserId() ?? '';
    
    // ✅ VÉRIFIER L'AUTHENTIFICATION
    if (!AuthGuard.isUserLoggedIn()) {
      // Initialiser avec liste vide
      _cartItemsFuture = Future.value([]);
      
      Future.delayed(Duration.zero, () {
        if (mounted) {
          AuthGuard.showAuthRequiredDialog(context);
          Navigator.pop(context);
        }
      });
      return;
    }

    _cartItemsFuture = _cartService.getUserCart(_userId);
  }

  void _refreshCart() {
    setState(() {
      _cartItemsFuture = _cartService.getUserCart(_userId);
    });
  }

  void _removeFromCart(String cartItemId) async {
    try {
      await _cartService.removeFromCart(cartItemId);
      _refreshCart();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  void _updateQuantity(String cartItemId, int newQuantity) async {
    try {
      await _cartService.updateCartItemQuantity(
        cartItemId: cartItemId,
        quantity: newQuantity,
      );
      _refreshCart();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
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
      body: FutureBuilder<List<CartItemModel>>(
        future: _cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(message: 'Chargement du panier...');
          }

          if (snapshot.hasError) {
            return custom_error.ErrorWidget(
              message: 'Erreur lors du chargement du panier',
              onRetry: _refreshCart,
            );
          }

          final cartItems = snapshot.data ?? [];

          if (cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Votre panier est vide',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryBlue.withOpacity(0.3),
                          blurRadius: 24,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (widget.onReturnHome != null) {
                          widget.onReturnHome!();
                        } else {
                          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                        }
                      },
                      child: const Text('Continuer les achats', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                    ),
                  ),
                ],
              ),
            );
          }

          double total = 0;
          for (var item in cartItems) {
            total += item.getTotalPrice();
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartItems[index];
                    return CartItemCard(
                      cartItem: cartItem,
                      onIncrement: () => _updateQuantity(
                        cartItem.id,
                        cartItem.quantity + 1,
                      ),
                      onDecrement: () => _updateQuantity(
                        cartItem.id,
                        cartItem.quantity - 1,
                      ),
                      onRemove: () => _removeFromCart(cartItem.id),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  border: Border(
                    top: BorderSide(color: isDark ? Colors.white10 : Colors.grey[300]!),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          '${total.toStringAsFixed(2)} MRU',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppTheme.accentGold : Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      label: 'Procéder au paiement',
                      icon: Icons.payment,
                      onPressed: () {
                        Navigator.pushNamed(context, '/checkout',
                            arguments: {'cartItems': cartItems, 'total': total});
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
