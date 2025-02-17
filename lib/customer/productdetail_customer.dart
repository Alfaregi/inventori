import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cart_customer.dart'; // Import cart page

class ProductDetailPage extends StatelessWidget {
  final int productId;

  ProductDetailPage({required this.productId});

  Future<Product> fetchProductDetails() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2/beinventori/detailproduct.php?product_id=$productId'));

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product details');
    }
  }

  Future<void> _showQuantityDialog(
      BuildContext context, Product product) async {
    if (product.stock == 0) {
      // Show a message if the stock is 0
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'This product is out of stock and cannot be added to the cart.'),
        ),
      );
      return; // Exit the function early to prevent the dialog from showing
    }

    int quantity = 1; // Default quantity

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Quantity'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('How many would you like to add to the cart?'),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (quantity > 1) {
                          quantity--;
                          (context as Element).markNeedsBuild();
                        }
                      },
                    ),
                    Text(quantity.toString(), style: TextStyle(fontSize: 24)),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        if (quantity < product.stock) {
                          quantity++;
                          (context as Element).markNeedsBuild();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Cannot exceed stock limit of ${product.stock}'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add to Cart'),
              onPressed: () {
                Navigator.of(context).pop();
                // Add the product to the cart with the selected quantity
                CartPage.addToCart(product, quantity); // Call the static method
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added to cart!'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: FutureBuilder<Product>(
        future: fetchProductDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No product found'));
          } else {
            final product = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      product.imageUrl,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 16),
                    Text(
                      '${product.name}',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      product.description,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Product Detail',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ProductDetailRow(
                        label: 'Price',
                        value: 'IDR ${product.price.toStringAsFixed(0)}'),
                    ProductDetailRow(
                        label: 'Stock', value: product.stock.toString()),
                    ProductDetailRow(
                        label: 'Description', value: product.description),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _showQuantityDialog(context, product);
                      },
                      child: Text('Add to Cart'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class Product {
  final int productId; // Ensure this is an int
  final String name;
  final double price;
  final String imageUrl;
  final int stock;
  final String description;

  Product({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.stock,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId:
          int.tryParse(json['product_id'].toString()) ?? 0, // Convert to int
      name: json['name'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      imageUrl: json['image'],
      stock: int.tryParse(json['stock'].toString()) ?? 0,
      description: json['description'],
    );
  }
}

class ProductDetailRow extends StatelessWidget {
  final String label;
  final String value;

  ProductDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value, textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
