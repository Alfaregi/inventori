import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Detail',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ProductDetailPage(),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Aksi untuk pencarian
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Menambahkan scrollable
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                'https://via.placeholder.com/300', // Ganti dengan URL gambar produk
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              Text(
                '\$229.99',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Potensic ATOM SE GPS Drone with 4K EIS Camera, Under 249g, 62 Mins Flight, 4KM FPV Transmission, Brushless Motor, Max Speed 16m/s, Auto Return, Lightweight and Foldable Drone for Adults, Beginner',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Product Detail',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ProductDetailRow(label: 'Brand', value: 'Potensic'),
              ProductDetailRow(label: 'Model Name', value: 'ATOM SE'),
              ProductDetailRow(label: 'Special Feature', value: '62 Mins Flight, 4KM FPV Transmission, <249g, Lightweight and Foldable Drone for Adults, 4K EIS Camera'),
              ProductDetailRow(label: 'Color', value: 'Gray'),
              ProductDetailRow(label: 'Video Capture Resolution', value: '4K'),
              ProductDetailRow(label: 'Effective Skill Resolution', value: '12.0'),
              ProductDetailRow(label: 'Connectivity Technology', value: 'Wi-Fi'),
              ProductDetailRow(label: 'Skill Level', value: 'Beginner'),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Aksi untuk membeli
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Buying now...')),
                      );
                    },
                    child: Text('Buy Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Aksi untuk menambahkan ke keranjang
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added to cart!')),
                      );
                    },
                    child: Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
