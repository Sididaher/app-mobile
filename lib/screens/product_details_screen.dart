import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Détails Produit',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du produit
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[200],
              child: Image.network(
                widget.product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Nom et prix
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        widget.product.rating.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        widget.product.category,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${widget.product.price.toStringAsFixed(2)} MRU',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Quantité
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Text(
                    'Quantité: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: _quantity > 1
                        ? () {
                            setState(() => _quantity--);
                          }
                        : null,
                  ),
                  Text(
                    _quantity.toString(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() => _quantity++);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Bouton Ajouter au panier
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${widget.product.name} x $_quantity ajouté au panier',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Ajouter au Panier'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
