import 'product_model.dart';

class CartItemModel {
  final String id;
  final String userId;
  final String productId;
  final int quantity;
  final DateTime addedAt;
  
  // Propriété de commodité (non stockée en BD)
  ProductModel? product;

  CartItemModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.addedAt,
    this.product,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      userId: json['user_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      addedAt: DateTime.parse(json['added_at']),
      product: json['products'] != null 
          ? ProductModel.fromJson(json['products']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
      'added_at': addedAt.toIso8601String(),
    };
  }

  // Calcul du prix total du panier
  double getTotalPrice() {
    if (product == null) return 0;
    return product!.price * quantity;
  }
}
