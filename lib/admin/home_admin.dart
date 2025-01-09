import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:inventori/admin/profile_admin.dart';
import 'package:inventori/admin/report_admin.dart';
import 'package:inventori/admin/updateproduct_admin.dart';
import 'package:inventori/admin/addproduct_admin.dart';
import 'package:inventori/admin/checkout_admin.dart';

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
  AdminHomePageState createState() => AdminHomePageState();
}

class AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;
  List<Product> products = [];
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Fetch product data when the page loads
  }

  Future<void> fetchProducts() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2/beinventori/getproduct_admin.php'));

    if (response.statusCode == 200) {
      try {
        List<dynamic> data = json.decode(response.body);
        print('Data received: $data'); // Debug statement
        setState(() {
          products = data.map((item) => Product.fromJson(item)).toList();
          _initializePages(); // Initialize pages after products are fetched
        });
      } catch (e) {
        print('Error decoding data: $e');
      }
    } else {
      print('Failed to load products. Status code: ${response.statusCode}');
    }
  }

  void _initializePages() {
    _pages.clear();
    _pages.add(AdminHomePageContent(products: products));
    _pages.add(AdminReportPage());
    _pages.add(CheckoutPage());
    _pages.add(AdminProfilePage());
  }

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
              // Action for notifications
            },
          ),
        ],
      ),
      body: _pages.isNotEmpty
          ? _pages[_selectedIndex]
          : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Report'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Checkout'),
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
  final List<Product> products;

  AdminHomePageContent({required this.products});

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
              StatCard(
                  label: 'Total Products',
                  value: products.length.toString(),
                  color: Colors.pink),
              StatCard(
                  label: 'Total Transaction', value: '10', color: Colors.blue),
              StatCard(
                  label: 'Income', value: 'IDR 750.000', color: Colors.green),
              StatCard(label: 'Check Out', value: '3', color: Colors.orange),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateProductPage1()));
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddProductPage()));
                },
                child: Text('Add Product'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
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
            child: products.isNotEmpty
                ? ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductListItem(product: products[index]);
                    },
                  )
                : Center(child: Text('No products available')),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String name;
  final String description; // Add this if you want to display the description
  final int quantity;
  final String imageUrl;

  Product({
    required this.name,
    required this.description,
    required this.quantity,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    print('JSON data: $json'); // Debug statement
    return Product(
      name: json['name'] ?? 'Unknown Product',
      description: json['description'] ?? 'No Description',
      quantity: int.tryParse(json['stock'].toString()) ?? 0,
      imageUrl: json['image'] ?? '',
    );
  }
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
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
        leading: Image.network(
          product.imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.image, size: 50), // Default icon if image fails
        ),
        title: Text(product.name.isNotEmpty ? product.name : 'No Name'),
        subtitle: Text(product.description), // Display description
        trailing: Text('Qty ${product.quantity}'),
      ),
    );
  }
}
