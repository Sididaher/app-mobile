import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel cartItem;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.cartItem,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final product = cartItem.product;
    if (product == null) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
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
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: product.imageUrl != null
                    ? product.imageUrl!.startsWith('assets/')
                        ? Image.asset(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_outlined),
                          )
                        : Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_outlined),
                          )
                    : const Icon(Icons.image_outlined),
              ),
            ),
            const SizedBox(width: 12),
            // Détails
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.price.toStringAsFixed(2)} MRU',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Contrôles de quantité
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: onDecrement,
                        iconSize: 18,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                      SizedBox(
                        width: 30,
                        child: Text(
                          '${cartItem.quantity}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: onIncrement,
                        iconSize: 18,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Total et supprimer
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${cartItem.getTotalPrice().toStringAsFixed(2)} MRU',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onRemove,
                  iconSize: 20,
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
