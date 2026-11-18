import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/product.dart';
import 'detail_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartBox = Hive.box('cart');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
      ),

      body: ValueListenableBuilder(
        valueListenable: cartBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Keranjang masih kosong',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }

          final products = box.values.map((item) {
            return Product.fromMap(item);
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return Card(
                margin:
                    const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.all(10),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPage(
                          productId: product.id,
                        ),
                      ),
                    );
                  },

                  leading: SizedBox(
                    width: 65,
                    height: 65,
                    child: Image.network(
                      product.image,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (_, _, _) {
                        return const Icon(
                          Icons.image_not_supported,
                        );
                      },
                    ),
                  ),

                  title: Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          Text(
                            '${product.rating}',
                          ),
                        ],
                      ),
                    ],
                  ),

                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      await box.delete(product.id);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}