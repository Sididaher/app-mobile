import 'package:supabase_flutter/supabase_flutter.dart';

class WishlistService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Ajouter ou supprimer un produit des favoris
  Future<bool> toggleWishlist({
    required String userId,
    required String productId,
  }) async {
    try {
      // Vérifier si le produit est déjà en favori
      final response = await _supabase
          .from('wishlist')
          .select()
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();

      if (response == null) {
        // Ajouter
        await _supabase.from('wishlist').insert({
          'user_id': userId,
          'product_id': productId,
        });
        return true;
      } else {
        // Supprimer
        await _supabase
            .from('wishlist')
            .delete()
            .eq('user_id', userId)
            .eq('product_id', productId);
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les IDs des produits en favoris pour un utilisateur
  Stream<List<String>> getWishlistProductIds(String userId) {
    return _supabase
        .from('wishlist')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((rows) => rows.map((row) => row['product_id'] as String).toList());
  }

  // Vérifier si un produit spécifique est en favori (utile si on ne veut pas streamer toute la liste)
  Future<bool> isFavorite(String userId, String productId) async {
    try {
      final response = await _supabase
          .from('wishlist')
          .select()
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();
      return response != null;
    } catch (e) {
      return false;
    }
  }

  // Récupérer les produits complets des favoris d'un utilisateur
  Future<List<dynamic>> getUserWishlistProductsRaw(String userId) async {
    try {
      final response = await _supabase
          .from('wishlist')
          .select('..., products(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return response as List<dynamic>;
    } catch (e) {
      rethrow;
    }
  }
}
