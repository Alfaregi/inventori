import 'package:flutter/material.dart';  
import 'package:http/http.dart' as http;  
import 'dart:convert';  
import 'productdetail_customer.dart'; // Import the product detail page  
  
void main() {  
  runApp(MyApp());  
}  
  
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
  Future<List<Product>> fetchProducts() async {  
    final response =  
        await http.get(Uri.parse('http://10.0.2.2/beinventori/getproduct_admin.php'));  
  
    if (response.statusCode == 200) {  
      List<dynamic> data = json.decode(response.body);  
      return data.map((product) => Product.fromJson(product)).toList();  
    } else {  
      throw Exception('Failed to load products');  
    }  
  }  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        title: Text('Shopping Page'),  
      ),  
      body: FutureBuilder<List<Product>>(  
        future: fetchProducts(),  
        builder: (context, snapshot) {  
          if (snapshot.connectionState == ConnectionState.waiting) {  
            return Center(child: CircularProgressIndicator());  
          } else if (snapshot.hasError) {  
            return Center(child: Text('Error: ${snapshot.error}'));  
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {  
            return Center(child: Text('No products found'));  
          } else {  
            return Column(  
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
                    itemCount: snapshot.data!.length,  
                    itemBuilder: (context, index) {  
                      return ProductCard(product: snapshot.data![index]);  
                    },  
                  ),  
                ),  
              ],  
            );  
          }  
        },  
      ),  
    );  
  }  
}  
  
class Product {  
  final int id; // Keep id as int  
  final String name;  
  final double price;  
  final String imageUrl;  
  
  Product({required this.id, required this.name, required this.price, required this.imageUrl});  
  
  factory Product.fromJson(Map<String, dynamic> json) {  
    return Product(  
      id: int.tryParse(json['id'].toString()) ?? 0, // Convert to int safely  
      name: json['name'],  
      price: double.tryParse(json['price'].toString()) ?? 0.0,  
      imageUrl: json['image'],  
    );  
  }  
}  
  
class ProductCard extends StatelessWidget {  
  final Product product;  
  
  ProductCard({required this.product});  
  
  @override  
  Widget build(BuildContext context) {  
    return GestureDetector(  
      onTap: () {  
        // Navigate to product detail page  
        Navigator.push(  
          context,  
          MaterialPageRoute(  
              builder: (context) => ProductDetailPage(productId: product.id)), // Pass product ID  
        );  
      },  
      child: Card(  
        elevation: 4,  
        child: Column(  
          crossAxisAlignment: CrossAxisAlignment.start,  
          children: [  
            Center(  
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
                'IDR ${product.price.toStringAsFixed(0)}',  
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),  
              ),  
            ),  
          ],  
        ),  
      ),  
    );  
  }  
}  
