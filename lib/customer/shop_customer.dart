import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'productdetail_customer.dart'; // Import halaman detail produk

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halaman Belanja',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ShoppingPage(),
    );
  }
}

class ShoppingPage extends StatefulWidget {
  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2/beinventori/getproduct_admin.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      products = data.map((product) => Product.fromJson(product)).toList();
      filteredProducts = products; // Inisialisasi produk yang difilter
      setState(() {});
    } else {
      throw Exception('Gagal memuat produk');
    }
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      filteredProducts = products;
    } else {
      filteredProducts = products.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Belanja'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: filterProducts, // Panggil filter saat teks berubah
              decoration: InputDecoration(
                hintText: 'Cari',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(child: Text('Tidak ada produk ditemukan'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: filteredProducts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final int product_id;
  final String name;
  final double price;
  final String imageUrl;

  Product(
      {required this.product_id,
      required this.name,
      required this.price,
      required this.imageUrl});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      product_id: int.tryParse(json['product_id'].toString()) ?? 0,
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
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProductDetailPage(productId: product.product_id)),
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
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
