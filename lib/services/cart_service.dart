import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cart_item_model.dart';

class CartService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Ajouter au panier
  Future<void> addToCart({
    required String userId,
    required String productId,
    int quantity = 1,
  }) async {
    try {
      // Vérifier si l'article existe déjà
      final existing = await _supabase
          .from('cart_items')
          .select()
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();

      if (existing != null) {
        // Augmenter la quantité
        await updateCartItemQuantity(
          cartItemId: existing['id'],
          quantity: existing['quantity'] + quantity,
        );
      } else {
        // Ajouter un nouvel article
        await _supabase.from('cart_items').insert({
          'user_id': userId,
          'product_id': productId,
          'quantity': quantity,
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer le panier avec les produits
  Future<List<CartItemModel>> getUserCart(String userId) async {
    try {
      final response = await _supabase
          .from('cart_items')
          .select('*, products(*)')
          .eq('user_id', userId);

      return (response as List)
          .map((json) => CartItemModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour la quantité d'un article
  Future<void> updateCartItemQuantity({
    required String cartItemId,
    required int quantity,
  }) async {
    try {
      if (quantity <= 0) {
        // Supprimer si quantité <= 0
        await _supabase.from('cart_items').delete().eq('id', cartItemId);
      } else {
        await _supabase
            .from('cart_items')
            .update({'quantity': quantity})
            .eq('id', cartItemId);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Supprimer un article du panier
  Future<void> removeFromCart(String cartItemId) async {
    try {
      await _supabase.from('cart_items').delete().eq('id', cartItemId);
    } catch (e) {
      rethrow;
    }
  }

  // Vider le panier
  Future<void> clearCart(String userId) async {
    try {
      await _supabase.from('cart_items').delete().eq('user_id', userId);
    } catch (e) {
      rethrow;
    }
  }

  // Calculer le total du panier
  Future<double> getCartTotal(String userId) async {
    try {
      final cartItems = await getUserCart(userId);
      double total = 0;
      for (var item in cartItems) {
        total += item.getTotalPrice();
      }
      return total;
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer le nombre d'articles dans le panier
  Future<int> getCartItemCount(String userId) async {
    try {
      final response = await _supabase
          .from('cart_items')
          .select()
          .eq('user_id', userId);

      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }
}
