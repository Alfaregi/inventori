import 'package:flutter/material.dart';
import 'package:inventori/admin/updateproduct2_admin.dart'; // Pastikan jalur ini benar

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Update Product',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: UpdateProductPage1(),
    );
  }
}

class UpdateProductPage1 extends StatelessWidget {
  final List<Product> products = [
    Product(name: 'Car Steering Wheel', quantity: 12, imageUrl: 'https://via.placeholder.com/100'),
    Product(name: 'Car Mirror', quantity: 12, imageUrl: 'https://via.placeholder.com/100'),
    Product(name: 'Car AC Filter', quantity: 12, imageUrl: 'https://via.placeholder.com/100'),
    Product(name: 'Car Turn Signal', quantity: 12, imageUrl: 'https://via.placeholder.com/100'),
    Product(name: 'Front Car Light', quantity: 12, imageUrl: 'https://via.placeholder.com/100'),
    Product(name: 'Car Gears', quantity: 0, imageUrl: 'https://via.placeholder.com/100'),
    Product(name: 'Car Rear View Mirror', quantity: 12, imageUrl: 'https://via.placeholder.com/100'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Product'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Aksi untuk kembali
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductListItem(
                    product: products[index],
                    onTap: () {
                      // Navigasi ke halaman detail produk
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateProductPage2(), // Ganti dengan halaman detail produk
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final int quantity;
  final String imageUrl;

  Product({required this.name, required this.quantity, required this.imageUrl});
}

class ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  ProductListItem({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Image.network(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(product.name),
        trailing: Text('Qty ${product.quantity}'),
        onTap: onTap, // Menambahkan aksi saat item diklik
      ),
    );
  }
}
