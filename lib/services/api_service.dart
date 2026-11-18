import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com/products';

  // Mengambil semua produk
  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map((item) => Product.fromJson(item))
          .toList();
    }

    throw Exception('Gagal mengambil data produk');
  }

  // Mengambil detail berdasarkan ID
  static Future<Product> getProductDetail(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return Product.fromJson(data);
    }

    throw Exception('Gagal mengambil detail produk');
  }
}