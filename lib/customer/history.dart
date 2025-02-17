import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity History',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HistoryPage(),
    );
  }
}

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2/beinventori/history.php'));

      if (response.statusCode == 200) {
        setState(() {
          orders = List<Order>.from(
              json.decode(response.body).map((x) => Order.fromJson(x)));
        });
      } else {
        throw Exception(
            'Gagal memuat pesanan, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your History',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return OrderCard(order: orders[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Order {
  final String name;
  final double price;
  final String status;
  final String quantity;
  final String created_at;
  final String image;

  Order({
    required this.name,
    required this.price,
    required this.status,
    required this.quantity,
    required this.created_at,
    required this.image,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      name: json['name'],
      price:
          double.tryParse(json['price'].toString()) ?? 0.0, // Perbaikan di sini
      status: json['status'],
      quantity: json['quantity'],
      created_at: json['created_at'],
      image: json['image'],
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.network(
              order.image,
              width: 100,
              height: 100,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image, size: 100);
              },
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('\$${order.price.toStringAsFixed(2)}'),
                  // Text('Status: ${order.status}',
                  //     style: TextStyle(
                  //         color: order.status == 'Finish'
                  //             ? Colors.green
                  //             : Colors.red)),
                  Text('Qty: ${order.quantity}'),
                  Text(order.created_at),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
