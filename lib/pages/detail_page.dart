import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import 'cart_page.dart';

class DetailPage extends StatefulWidget {
  final int productId;

  const DetailPage({
    super.key,
    required this.productId,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Product> productFuture;

  final cartBox = Hive.box('cart');

  @override
  void initState() {
    super.initState();

    productFuture =
        ApiService.getProductDetail(widget.productId);
  }

  bool isInCart(int id) {
    return cartBox.containsKey(id);
  }

  Future<void> toggleCart(Product product) async {
    if (isInCart(product.id)) {
      await cartBox.delete(product.id);
    } else {
      await cartBox.put(
        product.id,
        product.toJson(),
      );
    }

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isInCart(product.id)
              ? 'Produk ditambahkan ke keranjang'
              : 'Produk dihapus dari keranjang',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CartPage(),
                ),
              );
            },
          ),
        ],
      ),

      body: FutureBuilder<Product>(
        future: productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat detail produk',
              ),
            );
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // HERO IMAGE
                SizedBox(
                  height: 330,
                  width: double.infinity,
                  child: Hero(
                    tag: 'product-${product.id}',
                    child: Image.network(
                      product.image,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (_, _, _) {
                        return const Icon(
                          Icons.image_not_supported,
                          size: 70,
                        );
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${product.rating}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${product.ratingCount} reviews',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        product.description,
                        style: const TextStyle(
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            toggleCart(product);
                          },
                          icon: Icon(
                            isInCart(product.id)
                                ? Icons.remove_shopping_cart
                                : Icons.add_shopping_cart,
                          ),
                          label: Text(
                            isInCart(product.id)
                                ? 'Hapus dari Keranjang'
                                : 'Tambah ke Keranjang',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}