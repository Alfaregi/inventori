import 'package:flutter/material.dart';
import 'package:inventori/customer/productdetail_customer.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Page',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ShoppingPage(),
    );
  }
}

class ShoppingPage extends StatelessWidget {
  final List<Product> products = [
    Product(name: 'Fosmon X100 SE GPS Drone', price: 2290000, imageUrl: 'https://via.placeholder.com/150'), // Ubah harga ke IDR
    Product(name: 'COLIBRI 12 Pods Hydroponics', price: 430000, imageUrl: 'https://via.placeholder.com/150'),
    Product(name: 'Wi-Fi Soil Moisture Meter', price: 260000, imageUrl: 'https://via.placeholder.com/150'),
    Product(name: 'Dwi Dowellin Mini Drone', price: 390000, imageUrl: 'https://via.placeholder.com/150'),
    Product(name: '5x Tower Garden Hydroponics', price: 1180000, imageUrl: 'https://via.placeholder.com/150'),
    Product(name: 'Drone with Camera 2K', price: 890000, imageUrl: 'https://via.placeholder.com/150'),
    Product(name: 'Drone with dual camera', price: 700000, imageUrl: 'https://via.placeholder.com/150'),
    Product(name: 'Maxim Smart Plant Sport', price: 1280000, imageUrl: 'https://via.placeholder.com/150'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(product: products[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String name;
  final double price; // Harga dalam IDR
  final String imageUrl;

  Product({required this.name, required this.price, required this.imageUrl});

  get image => null;

  static fromJson(product) {}
}

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman detail produk
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailPage()),
        );
      },
      child: Card(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center( // Memusatkan gambar
              child: Image.network(
                product.imageUrl,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
                style: TextStyle(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                'IDR ${product.price.toStringAsFixed(0)}', // Ubah format harga ke IDR
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
