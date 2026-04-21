import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../services/order_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart' as custom_error;
import '../../core/utils/auth_guard.dart';
import '../../core/theme/app_theme.dart';


class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderService _orderService = OrderService();
  final AuthService _authService = AuthService();

  late String _userId;
  late Future<List<OrderModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    
    _userId = _authService.getCurrentUserId() ?? '';
    
    // ✅ VÉRIFIER L'AUTHENTIFICATION
    if (!AuthGuard.isUserLoggedIn()) {
      // Initialiser avec liste vide
      _ordersFuture = Future.value([]);
      
      Future.delayed(Duration.zero, () {
        if (mounted) {
          AuthGuard.showAuthRequiredDialog(context);
          Navigator.pop(context);
        }
      });
      return;
    }

    _ordersFuture = _orderService.getUserOrders(_userId);
  }

  void _refreshOrders() {
    setState(() {
      _ordersFuture = _orderService.getUserOrders(_userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Mes Commandes', 
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(message: 'Chargement des commandes...');
          }

          if (snapshot.hasError) {
            return custom_error.ErrorWidget(
              message: 'Erreur lors du chargement des commandes',
              onRetry: _refreshOrders,
            );
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Aucune commande',
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
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
                      child: const Text('Continuer les achats', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                    ),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.08),
                          blurRadius: 24,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: isDark ? Border.all(color: Colors.white10) : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Commande',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    order.id.substring(0, 8).toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: isDark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(order.orderStatus)
                                      .withAlpha(50),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  order.getStatusLabel(),
                                  style: TextStyle(
                                    color: _getStatusColor(order.orderStatus),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            order.customerName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            order.customerAddress,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order.createdAt.toString().split(' ')[0],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.white38 : Colors.grey[600],
                                ),
                              ),
                              Text(
                                '${order.totalAmount.toStringAsFixed(2)} MRU',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isDark ? AppTheme.accentGold : Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
