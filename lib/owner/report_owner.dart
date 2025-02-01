import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Report Page',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: OwnerReportPage(),
    );
  }
}

class OwnerReportPage extends StatelessWidget {
  final List<ReportItem> reportItems = [
    ReportItem(
      productName: 'Potensic ATOM SE',
      price: 750000,
      status: 'Finish',
      quantity: 1,
      date: '09 Desember 2024',
      imageUrl: 'http://10.0.2.2/beinventori/uploads/product_1736661686.jpg',
    ),
    ReportItem(
      productName: 'Potensic ATOM SE',
      price: 750000,
      status: 'Return',
      quantity: 1,
      date: '09 Desember 2024',
      imageUrl: 'http://10.0.2.2/beinventori/uploads/product_1736661686.jpg',
      // imageUrl: 'https://via.placeholder.com/100',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    int totalIncome = reportItems
        .where((item) =>
            item.status ==
            'Finish') // Hanya menghitung item dengan status 'Finish'
        .fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(
        title: Text('REPORT'),
        // Menghapus leading untuk menghilangkan tanda panah
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Income',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'IDR +$totalIncome',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: reportItems.length,
                itemBuilder: (context, index) {
                  return ReportCard(item: reportItems[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportItem {
  final String productName;
  final int price;
  final String status;
  final int quantity;
  final String date;
  final String imageUrl;

  ReportItem({
    required this.productName,
    required this.price,
    required this.status,
    required this.quantity,
    required this.date,
    required this.imageUrl,
  });
}

class ReportCard extends StatelessWidget {
  final ReportItem item;

  ReportCard({required this.item});

  @override
  Widget build(BuildContext context) {
    Color statusColor = item.status == 'Finish' ? Colors.green : Colors.red;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            Image.network(
              item.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('IDR ${item.price}'),
                  Text(
                    'Status: ${item.status}',
                    style: TextStyle(
                        color:
                            statusColor), // Mengubah warna teks berdasarkan status
                  ),
                  Text('Qty: ${item.quantity}'),
                  Text(item.date),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
