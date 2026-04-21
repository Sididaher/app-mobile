class OrderItemModel {
  final String id;
  final String orderId;
  final String productId;
  final int quantity;
  final double priceAtPurchase;
  final DateTime createdAt;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.priceAtPurchase,
    required this.createdAt,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      priceAtPurchase: (json['price_at_purchase'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      'price_at_purchase': priceAtPurchase,
    };
  }

  double getTotalPrice() => priceAtPurchase * quantity;
}
