class CategoryModel {
  final String id; // In this case, we use the name as ID if no dedicated table
  final String name;
  final String? imageUrl;

  CategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory CategoryModel.fromName(String name) {
    return CategoryModel(
      id: name,
      name: name,
      imageUrl: _getImageForCategory(name),
    );
  }

  static String? _getImageForCategory(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('shoe') || cat.contains('sneaker') || cat.contains('chaussure') || cat.contains('pied')) {
      return 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=300&auto=format&fit=crop';
    } else if (cat.contains('shirt') || cat.contains('clothing') || cat.contains('vêtement') || cat.contains('femme') || cat.contains('homme')) {
      return 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=300&auto=format&fit=crop';
    } else if (cat.contains('jean') || cat.contains('pant') || cat.contains('pantalon') || cat.contains('denim')) {
      return 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?q=80&w=300&auto=format&fit=crop';
    } else if (cat.contains('watch') || cat.contains('accessor') || cat.contains('accessoire') || cat.contains('bijou')) {
      return 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=300&auto=format&fit=crop';
    } else if (cat.contains('bag') || cat.contains('tote') || cat.contains('sac') || cat.contains('valise')) {
      return 'https://images.unsplash.com/photo-1584916201218-f4242ceb4809?q=80&w=300&auto=format&fit=crop';
    } else if (cat.contains('electro') || cat.contains('tech') || cat.contains('gadget') || cat.contains('phone')) {
      return 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?q=80&w=300&auto=format&fit=crop';
    }
    return 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?q=80&w=300&auto=format&fit=crop';
  }
}
