import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_model.dart';

class CategoryService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Stream categories directly from the products table (getting unique values)
  Stream<List<CategoryModel>> getCategoriesStream() {
    return _supabase
        .from('products')
        .stream(primaryKey: ['id'])
        .eq('is_active', true)
        .map((maps) {
          try {
            final categoryNames = maps
                .map((map) => (map['category'] as String?)?.trim() ?? 'Uncategorized')
                .where((name) => name.isNotEmpty)
                .toSet()
                .toList();
            categoryNames.sort();
            return categoryNames.map((name) => CategoryModel.fromName(name)).toList();
          } catch (e) {
            return <CategoryModel>[];
          }
        });
  }

  // Fetch categories once
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _supabase
          .from('products')
          .select('category')
          .eq('is_active', true);

      final categoryNames = (response as List)
          .map((json) => (json['category'] as String?)?.trim() ?? 'Uncategorized')
          .where((name) => name.isNotEmpty)
          .toSet()
          .toList();
      categoryNames.sort();
      
      return categoryNames.map((name) => CategoryModel.fromName(name)).toList();
    } catch (e) {
      return <CategoryModel>[];
    }
  }
}
