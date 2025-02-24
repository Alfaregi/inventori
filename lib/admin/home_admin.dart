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
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54),
        ),
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
    _pages.add(AdminHomePageContent(
      products: products,
      onRefresh: fetchProducts, // Pass the fetchProducts function
    ));
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
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey[600],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class AdminHomePageContent extends StatelessWidget {
  final List<Product> products;
  final Future<void> Function() onRefresh; // Add a callback for refresh

  AdminHomePageContent({required this.products, required this.onRefresh});

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
              Expanded(
                child: StatCard(
                  label: 'Total Products',
                  value: products.length.toString(),
                  color: Colors.pink,
                ),
              ),
              // StatCard(
              //     label: 'Total Transaction', value: '10', color: Colors.blue),
              // StatCard(
              //     label: 'Income', value: 'IDR 750.000', color: Colors.green),
              // StatCard(label: 'Check Out', value: '3', color: Colors.orange),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddProductPage()));
                  },
                  child: Text('Add Product'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text('Available Products',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Expanded(
            child: RefreshIndicator(
              onRefresh: onRefresh, // Set the refresh callback
              child: products.isNotEmpty
                  ? ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductListItem(
                          product: products[index],
                          onTap: () {
                            // Navigate to the update product page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateProductPage1(
                                    product: products[
                                        index]), // Pass the selected product
                              ),
                            ).then((_) {
                              // Refresh the product list after returning from the update page
                              onRefresh();
                            });
                          },
                        );
                      },
                    )
                  : Center(
                      child: Text('No products available',
                          style: TextStyle(fontSize: 18))),
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String product_id; // Add ID field
  final String name;
  final String place;
  final String description; // Add this if you want to display the description
  final int quantity;
  final String imageUrl;
  final double price; // Add price field

  Product({
    required this.product_id,
    required this.name,
    required this.place,
    required this.description,
    required this.quantity,
    required this.imageUrl,
    required this.price, // Include price in constructor
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      product_id: json['product_id'].toString(), // Ensure ID is a string
      name: json['name'] ?? 'Unknown Product',
      description: json['description'] ?? 'No Description',
      place: json['place'] ?? 'No Place',
      quantity: int.tryParse(json['stock'].toString()) ?? 0,
      imageUrl: json['image'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0, // Parse price
    );
  }

  get stock => null;

  get image => null;

  get id => null;
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        width: 80,
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback onTap; // Add onTap callback

  ProductListItem({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Print the image URL to the console
    print('Image URL: ${product.imageUrl}');

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        leading: ClipOval(
          child: Image.network(
            product.imageUrl, // Pastikan ini adalah URL yang benar
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.image, size: 50), // Default icon if image fails
          ),
        ),

        title: Text(product.name.isNotEmpty ? product.name : 'No Name',
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(product.description,
            style: TextStyle(color: Colors.black54)), // Display description
        trailing: Text('Qty ${product.quantity}',
            style: TextStyle(color: Colors.green)),
        onTap: onTap, // Add onTap action
      ),
    );
  }
}
