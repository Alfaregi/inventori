import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:inventori/owner/profile_owner.dart';
import 'package:inventori/owner/report_owner.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Owner Home Page',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54),
        ),
      ),
      home: OwnerHomePage(),
    );
  }
}

class OwnerHomePage extends StatefulWidget {
  @override
  OwnerHomePageState createState() => OwnerHomePageState();
}

class OwnerHomePageState extends State<OwnerHomePage> {
  int _selectedIndex = 0;
  List<Product> products = [];
  List<Map<String, dynamic>> pendingUpdates = [];

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Ambil data produk saat halaman dimuat
    fetchPendingUpdates(); // Ambil pembaruan yang menunggu saat halaman dimuat
  }

  Future<void> fetchProducts() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2/beinventori/getproduct_admin.php'));

    if (response.statusCode == 200) {
      try {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          products = data.map((item) => Product.fromJson(item)).toList();
        });
      } catch (e) {
        print('Error decoding data: $e');
      }
    } else {
      print('Failed to load products. Status code: ${response.statusCode}');
    }
  }

  Future<void> fetchPendingUpdates() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2/beinventori/getpendingupdates.php'));

    if (response.statusCode == 200) {
      try {
        final result = json.decode(response.body);
        if (result['status'] == 'success') {
          setState(() {
            pendingUpdates = List<Map<String, dynamic>>.from(result['data']);
          });
        }
      } catch (e) {
        print('Error decoding data: $e');
      }
    } else {
      print(
          'Failed to load pending updates. Status code: ${response.statusCode}');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> approveUpdate(int pendingUpdateId) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/beinventori/approveupdate.php'),
      body: {
        'product_id': pendingUpdateId.toString(),
      },
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product update approved.')),
        );
        fetchProducts(); // Segarkan produk setelah persetujuan
        fetchPendingUpdates(); // Segarkan pembaruan yang menunggu
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve product update.')),
      );
    }
  }

  Future<void> disapproveUpdate(int pendingUpdateId) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/beinventori/disapproveupdate.php'),
      body: {
        'product_id': pendingUpdateId.toString(),
      },
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product update disapproved.')),
        );
        fetchPendingUpdates(); // Segarkan pembaruan yang menunggu
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to disapprove product update.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      OwnerHomePageContent(
        products: products,
        pendingUpdates: pendingUpdates,
        approveUpdate: approveUpdate,
        disapproveUpdate: disapproveUpdate,
      ),
      OwnerReportPage(),
      OwnerProfilePage(),
    ];

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
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey[600],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class OwnerHomePageContent extends StatelessWidget {
  final List<Product> products;
  final List<Map<String, dynamic>> pendingUpdates;
  final Function(int) approveUpdate;
  final Function(int) disapproveUpdate;

  OwnerHomePageContent({
    required this.products,
    required this.pendingUpdates,
    required this.approveUpdate,
    required this.disapproveUpdate,
  });

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
          Text('Available Approval',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                final ownerHomePageState =
                    context.findAncestorStateOfType<OwnerHomePageState>();
                if (ownerHomePageState != null) {
                  await ownerHomePageState.fetchProducts();
                  await ownerHomePageState.fetchPendingUpdates();
                }
              },
              child: ListView.builder(
                itemCount: pendingUpdates.length,
                itemBuilder: (context, index) {
                  final update = pendingUpdates[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 2,
                    child: ListTile(
                      title: Text(update['name'],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      // subtitle: Text(update['description'],
                      //     style: TextStyle(color: Colors.black54)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.check, color: Colors.green),
                            onPressed: () => approveUpdate(
                                int.parse(update['product_id'].toString())),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed: () => disapproveUpdate(
                                int.parse(update['product_id'].toString())),
                          ),
                          Text('Qty ${update['stock']}',
                              style: TextStyle(color: Colors.green)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String product_id; // Tambahkan field ID
  final String name;
  // final String description; // Tambahkan ini jika ingin menampilkan deskripsi
  final int quantity;
  final String imageUrl;
  final double price; // Tambahkan field harga

  Product({
    required this.product_id,
    required this.name,
    // required this.description,
    required this.quantity,
    required this.imageUrl,
    required this.price, // Sertakan harga dalam konstruktor
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      product_id: json['product_id'].toString(), // Pastikan ID adalah string
      name: json['name'] ?? 'Unknown Product',
      // description: json['description'] ?? 'No Description',
      quantity: int.tryParse(json['stock'].toString()) ?? 0,
      imageUrl: json['image'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0, // Parse harga
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
