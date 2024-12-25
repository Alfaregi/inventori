import 'package:flutter/material.dart';
import 'package:inventori/admin/profile_admin.dart';
import 'package:inventori/admin/report_admin.dart';
import 'package:inventori/admin/updateproduct_admin.dart';
import 'package:inventori/admin/addproduct_admin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Home Page',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: AdminHomePage(),
    );
  }
}

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    AdminHomePageContent(),
    AdminReportPage(), // Halaman laporan keuangan
    AdminProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DKI JAYA STORE'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Aksi untuk notifikasi
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        backgroundColor: Colors.white,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey[300],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class AdminHomePageContent extends StatelessWidget {
  final List<Product> products = [
    Product(name: 'Car Steering Wheel', quantity: 12, imageUrl: 'https://via.placeholder.com/100'),
    Product(name: 'Car Mirror', quantity: 12, imageUrl: 'https://via.placeholder.com/100'),
    Product(name: 'Car AC Filter', quantity: 12, imageUrl: 'https://via.placeholder.com/100'),
    Product(name: 'Car Turn Signal', quantity: 12, imageUrl: 'https://via.placeholder.com/100'),
    Product(name: 'Front Car Light', quantity: 12, imageUrl: 'https://via.placeholder.com/100'),
    Product(name: 'Car Gears', quantity: 0, imageUrl: 'https://via.placeholder.com/100'),
    Product(name: 'Car Rear View Mirror', quantity: 9, imageUrl: 'https://via.placeholder.com/100'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatCard(label: 'Total Products', value: '200', color: Colors.pink),
              StatCard(label: 'Total Transaction', value: '10', color: Colors.blue),
              StatCard(label: 'Income', value: 'IDR 750.000', color: Colors.green),
              StatCard(label: 'Check Out', value: '3', color: Colors.orange),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateProductPage1())); // Aksi untuk menambah produk
                },
                child: Text('Update Product'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductPage()));// Aksi untuk mengedit produk
                },
                child: Text('Add Product'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Warna tombol edit
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Available Products',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductListItem(product: products[index]);
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
  final int quantity;
  final String imageUrl;

  Product({required this.name, required this.quantity, required this.imageUrl});
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ProductListItem extends StatelessWidget {
  final Product product;

  ProductListItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Image.network(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(product.name),
        trailing: Text('Qty ${product.quantity}'),
      ),
    );
  }
}
