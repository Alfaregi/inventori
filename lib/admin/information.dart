import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InformationPage extends StatefulWidget {
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2/beinventori/getproduct_admin.php'));

      if (response.statusCode == 200) {
        // Log the response body
        print('Response body: ${response.body}');

        if (response.headers['content-type']?.contains('application/json') ??
            false) {
          List<dynamic> data = jsonDecode(response.body);
          return data.map((product) => Product.fromJson(product)).toList();
        } else {
          throw Exception('Response is not JSON');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information'),
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];
                return ListTile(
                  leading:
                      Image.network(product.image), // Display product image
                  title: Text(product.productName),
                  subtitle: Text(
                    'Place: ${product.place}\nStock: ${product.stock}',
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Product {
  final String productName;
  final String place;
  final int stock;
  final String image;

  Product({
    required this.productName,
    required this.place,
    required this.stock,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productName: json['name'],
      place: json['place'],
      stock:
          int.tryParse(json['stock'].toString()) ?? 0, // Convert to int safely
      image: json['image'],
    );
  }
}
