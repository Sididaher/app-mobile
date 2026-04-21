import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';
import '../models/order_item_model.dart';
import '../models/cart_item_model.dart';
import '../core/constants/app_constants.dart';
import 'cart_service.dart';

class OrderService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final CartService _cartService = CartService();

  // Créer une commande à partir du panier
  Future<OrderModel?> createOrderFromCart({
    required String userId,
    required String customerName,
    required String customerEmail,
    required String customerAddress,
    required String customerPhone,
    required List<CartItemModel> cartItems,
    required double totalAmount,
  }) async {
    try {
      // Créer la commande
      final orderResponse = await _supabase
          .from('orders')
          .insert({
            'user_id': userId,
            'total_amount': totalAmount,
            'order_status': AppConstants.orderStatusPending,
            'customer_name': customerName,
            'customer_email': customerEmail,
            'customer_address': customerAddress,
            'customer_phone': customerPhone,
          })
          .select()
          .single();

      final orderId = orderResponse['id'];

      // Créer les order_items
      for (var cartItem in cartItems) {
        await _supabase.from('order_items').insert({
          'order_id': orderId,
          'product_id': cartItem.productId,
          'quantity': cartItem.quantity,
          'price_at_purchase': cartItem.product?.price ?? 0,
        });
      }

      // Vider le panier
      await _cartService.clearCart(userId);

      return OrderModel.fromJson(orderResponse);
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les commandes de l'utilisateur
  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      final response = await _supabase
          .from('orders')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => OrderModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer les détails d'une commande
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final response = await _supabase
          .from('orders')
          .select()
          .eq('id', orderId)
          .single();

      return OrderModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Récupérer les articles d'une commande
  Future<List<OrderItemModel>> getOrderItems(String orderId) async {
    try {
      final response = await _supabase
          .from('order_items')
          .select()
          .eq('order_id', orderId);

      return (response as List)
          .map((json) => OrderItemModel.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Mettre à jour le statut d'une commande
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _supabase
          .from('orders')
          .update({'order_status': newStatus})
          .eq('id', orderId);
    } catch (e) {
      rethrow;
    }
  }

  // Annuler une commande
  Future<void> cancelOrder(String orderId) async {
    try {
      await updateOrderStatus(orderId, AppConstants.orderStatusCancelled);
    } catch (e) {
      rethrow;
    }
  }

  // Récupérer le nombre de commandes
  Future<int> getUserOrdersCount(String userId) async {
    try {
      final response = await _supabase
          .from('orders')
          .select()
          .eq('user_id', userId);

      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }
}
