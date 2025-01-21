import 'package:flutter/material.dart';  
import 'package:http/http.dart' as http;  
import 'dart:convert';  
import 'package:inventori/customer/cart_customer.dart';  
import 'package:inventori/customer/profile_customer.dart';  
import 'package:inventori/customer/shop_customer.dart';  
import 'package:inventori/customer/productdetail_customer.dart';  
  
void main() {  
  runApp(MyApp());  
}  
  
class MyApp extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
    return MaterialApp(  
      home: HomePage(),  
    );  
  }  
}  
  
class HomePage extends StatefulWidget {  
  @override  
  _HomePageState createState() => _HomePageState();  
}  
  
class _HomePageState extends State<HomePage> {  
  int _selectedIndex = 0; // Store the selected page index  
  
  // List of pages to display  
  final List<Widget> _pages = [  
    HomeContent(), // Main page  
    ShoppingPage(), // Shopping page  
    CartPage(quantity: 0), // Cart page with default quantity  
    ProfilePage(), // Profile page  
  ];  
  
  void _onItemTapped(int index) {  
    setState(() {  
      _selectedIndex = index; // Change the selected page  
    });  
  }  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        backgroundColor: Colors.grey[200],  
        title: Text('DKI JAYA STORE'),  
        actions: [  
          IconButton(  
            icon: Icon(Icons.notifications),  
            onPressed: () {},  
          ),  
        ],  
      ),  
      body: _pages[_selectedIndex], // Display the selected page  
      bottomNavigationBar: BottomNavigationBar(  
        backgroundColor: Colors.white,  
        selectedItemColor: Colors.teal,  
        unselectedItemColor: Colors.grey[300],  
        currentIndex: _selectedIndex, // Mark the selected item  
        onTap: _onItemTapped, // Handle tap on item  
        items: [  
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),  
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Shop'),  
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),  
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),  
        ],  
      ),  
    );  
  }  
}  
  
class HomeContent extends StatefulWidget {  
  @override  
  _HomeContentState createState() => _HomeContentState();  
}  
  
class _HomeContentState extends State<HomeContent> {  
  late Future<List<Product>> futureProducts;  
  
  @override  
  void initState() {  
    super.initState();  
    futureProducts = fetchProducts();  
  }  
  
  Future<List<Product>> fetchProducts() async {  
    final response = await http.get(Uri.parse('http://10.0.2.2/beinventori/getproduct_admin.php'));  
  
    if (response.statusCode == 200) {  
      List jsonResponse = json.decode(response.body);  
      return jsonResponse.map((product) => Product.fromJson(product)).toList();  
    } else {  
      throw Exception('Failed to load products');  
    }  
  }  
  
  @override  
  Widget build(BuildContext context) {  
    return SingleChildScrollView(  
      child: Column(  
        crossAxisAlignment: CrossAxisAlignment.start,  
        children: [  
          Container(  
            color: Colors.greenAccent,  
            padding: EdgeInsets.all(16),  
            height: 200,  
            child: Row(  
              children: [  
                Image.asset(  
                  'assets/images/ban.png',  
                  width: 250,  
                  height: 250,  
                ),  
                SizedBox(width: 16),  
                Column(  
                  mainAxisAlignment: MainAxisAlignment.center,  
                  children: [  
                    Text(  
                      'Car Wheel',  
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),  
                    ),  
                    Text('Start from'),  
                    Text(  
                      'IDR 400.000',  
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),  
                    ),  
                  ],  
                ),  
              ],  
            ),  
          ),  
          Padding(  
            padding: const EdgeInsets.all(16.0),  
            child: Text(  
              'Start your journey with us.',  
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),  
            ),  
          ),  
          FutureBuilder<List<Product>>(  
            future: futureProducts,  
            builder: (context, snapshot) {  
              if (snapshot.connectionState == ConnectionState.waiting) {  
                return Center(child: CircularProgressIndicator());  
              } else if (snapshot.hasError) {  
                return Center(child: Text('Error: ${snapshot.error}'));  
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {  
                return Center(child: Text('No products found'));  
              } else {  
                List<Product> products = snapshot.data!;  
                return GridView.builder(  
                  shrinkWrap: true,  
                  physics: NeverScrollableScrollPhysics(),  
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(  
                    crossAxisCount: 2,  
                    childAspectRatio: 0.75,  
                  ),  
                  itemCount: products.length,  
                  itemBuilder: (context, index) {  
                    return ProductCard(  
                      imageUrl: products[index].image,  
                      name: products[index].name,  
                      price: 'IDR ${products[index].price.toStringAsFixed(0)}',  
                      onTap: () {  
                        Navigator.push(  
                          context,  
                          MaterialPageRoute(  
                            builder: (context) => ProductDetailPage(productId: products[index].id),  
                          ),  
                        );  
                      },  
                    );  
                  },  
                );  
              }  
            },  
          ),  
        ],  
      ),  
    );  
  }  
}  
  
class Product {  
  final int id;  
  final String name;  
  final int stock;  
  final double price;  
  final String image;  
  
  Product({  
    required this.id,  
    required this.name,  
    required this.stock,  
    required this.price,  
    required this.image,  
  });  
  
  factory Product.fromJson(Map<String, dynamic> json) {  
    return Product(  
      id: int.parse(json['id'].toString()),  
      name: json['name'],  
      stock: int.parse(json['stock'].toString()),  
      price: double.parse(json['price'].toString()),  
      image: json['image'],  
    );  
  }  
}  
  
class ProductCard extends StatelessWidget {  
  final String imageUrl;  
  final String name;  
  final String price;  
  final VoidCallback onTap;  
  
  ProductCard({  
    required this.imageUrl,  
    required this.name,  
    required this.price,  
    required this.onTap,  
  });  
  
  @override  
  Widget build(BuildContext context) {  
    return GestureDetector(  
      onTap: onTap,  
      child: Card(  
        child: Padding(  
          padding: const EdgeInsets.all(8.0),  
          child: Column(  
            children: [  
              Expanded(  
                child: Image.network(  
                  imageUrl,  
                  width: 100,  
                  height: 100,  
                  fit: BoxFit.cover,  
                  errorBuilder: (context, error, stackTrace) {  
                    return Center(child: Text('Image not found'));  
                  },  
                ),  
              ),  
              SizedBox(height: 8),  
              Text(  
                name,  
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),  
              ),  
              SizedBox(height: 4),  
              Text(  
                price,  
                style: TextStyle(fontSize: 12),  
              ),  
            ],  
          ),  
        ),  
      ),  
    );  
  }  
}  
