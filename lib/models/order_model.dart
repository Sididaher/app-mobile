class OrderModel {
  final String id;
  final String userId;
  final double totalAmount;
  final String orderStatus;
  final String customerName;
  final String customerEmail;
  final String customerAddress;
  final String customerPhone;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.orderStatus,
    required this.customerName,
    required this.customerEmail,
    required this.customerAddress,
    required this.customerPhone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['user_id'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      orderStatus: json['order_status'],
      customerName: json['customer_name'],
      customerEmail: json['customer_email'],
      customerAddress: json['customer_address'],
      customerPhone: json['customer_phone'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'total_amount': totalAmount,
      'order_status': orderStatus,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'customer_address': customerAddress,
      'customer_phone': customerPhone,
    };
  }

  String getStatusLabel() {
    switch (orderStatus) {
      case 'pending':
        return 'En attente';
      case 'confirmed':
        return 'Confirmée';
      case 'shipped':
        return 'Expédiée';
      case 'delivered':
        return 'Livrée';
      case 'cancelled':
        return 'Annulée';
      default:
        return 'Inconnu';
    }
  }
}
