import 'package:flutter/material.dart';
import '../../models/cart_item_model.dart';
import '../../services/order_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../core/utils/auth_guard.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItemModel> cartItems;
  final double total;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.total,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isCreatingOrder = false;
  final OrderService _orderService = OrderService();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    
    // ✅ VÉRIFIER L'AUTHENTIFICATION
    if (!AuthGuard.isUserLoggedIn()) {
      Future.delayed(Duration.zero, () {
        if (mounted) {
          AuthGuard.showAuthRequiredDialog(context);
          Navigator.pop(context);
        }
      });
      return;
    }

    _preloadUserData();
  }

  void _preloadUserData() async {
    final user = await _authService.getCurrentUser();
    if (user != null && mounted) {
      _emailController.text = user.email;
      _nameController.text = user.fullName ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _createOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isCreatingOrder = true);

    try {
      final userId = _authService.getCurrentUserId();
      if (userId == null) throw Exception('Utilisateur non connecté');

      await _orderService.createOrderFromCart(
        userId: userId,
        customerName: _nameController.text,
        customerEmail: _emailController.text,
        customerAddress: _addressController.text,
        customerPhone: _phoneController.text,
        cartItems: widget.cartItems,
        totalAmount: widget.total,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Commande créée avec succès!')),
        );
        Navigator.of(context)
            .pushReplacementNamed('/home')
            .then((_) {
              Navigator.pushNamed(context, '/orders');
            });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreatingOrder = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commande'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Résumé de la Commande',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${widget.cartItems.length} article(s)',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.total.toStringAsFixed(2)} MRU',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Informations de Livraison',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nom Complet',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Requis' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Requis' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Adresse',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Requis' : null,
                  minLines: 2,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Téléphone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Requis' : null,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  label: 'Confirmer la Commande',
                  icon: Icons.check,
                  isLoading: _isCreatingOrder,
                  onPressed: _createOrder,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
