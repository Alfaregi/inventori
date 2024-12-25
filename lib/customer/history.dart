import 'package:flutter/material.dart';


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

class HistoryPage extends StatelessWidget {
  final List<Order> orders = [
    Order(
      productName: 'Potensic ATOM SE GPS Drone',
      price: 229.99,
      status: 'Finish',
      quantity: 1,
      date: '09 Desember 2024',
      imageUrl: 'https://via.placeholder.com/100', // Ganti dengan URL gambar produk
    ),
    Order(
      productName: 'Potensic ATOM SE GPS Drone',
      price: 229.99,
      status: 'Return',
      quantity: 1,
      date: '09 Desember 2024',
      imageUrl: 'https://via.placeholder.com/100', // Ganti dengan URL gambar produk
    ),
  ];

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
  final String productName;
  final double price;
  final String status;
  final int quantity;
  final String date;
  final String imageUrl;

  Order({
    required this.productName,
    required this.price,
    required this.status,
    required this.quantity,
    required this.date,
    required this.imageUrl,
  });
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
              order.imageUrl,
              width: 100,
              height: 100,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.productName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('\$${order.price.toStringAsFixed(2)}'),
                  Text('Status: ${order.status}', style: TextStyle(color: order.status == 'Finish' ? Colors.green : Colors.red)),
                  Text('Qty: ${order.quantity}'),
                  Text(order.date),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
