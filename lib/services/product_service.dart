import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';

class ProductService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Récupérer tous les produits actifs
  Future<List<ProductModel>> getActiveProducts() async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer un produit par ID
  Future<ProductModel?> getProductById(String productId) async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .eq('id', productId)
          .single();

      return ProductModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Récupérer les produits par catégorie
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .eq('category', category)
          .eq('is_active', true);

      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Rechercher des produits
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await _supabase
          .from('products')
          .select()
          .eq('is_active', true)
          .ilike('name', '%$query%');

      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les catégories disponibles
  Future<List<String>> getCategories() async {
    try {
      final response = await _supabase
          .from('products')
          .select('category')
          .eq('is_active', true);

      // Use Set to deduplicate categories (distinct not available in Postgrest)
      final categories = (response as List)
          .map((json) => json['category'] as String)
          .toSet()
          .toList();
      categories.sort();
      
      return categories;
    } catch (e) {
      rethrow;
    }
  }
  
  // --- REALTIME STREAMS ---

  // Stream pour observer les produits en temps réel
  Stream<List<ProductModel>> getProductsStream() {
    return _supabase
        .from('products')
        .stream(primaryKey: ['id'])
        .eq('is_active', true)
        .order('created_at', ascending: false)
        .map((maps) => maps.map((map) => ProductModel.fromJson(map)).toList());
  }

  // Stream pour observer les catégories en temps réel
  Stream<List<String>> getCategoriesStream() {
    return _supabase
        .from('products')
        .stream(primaryKey: ['id'])
        .eq('is_active', true)
        .map((maps) {
          final categories = maps.map((map) => map['category'] as String).toSet().toList();
          categories.sort();
          return categories;
        });
  }
}
