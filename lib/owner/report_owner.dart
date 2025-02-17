import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

class OwnerReportPage extends StatefulWidget {
  @override
  _OwnerReportPageState createState() => _OwnerReportPageState();
}

class _OwnerReportPageState extends State<OwnerReportPage> {
  List<ReportItem> reportItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2/beinventori/history.php'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          reportItems = data
              .map((item) => ReportItem(
                    productName: item['name'],
                    price: int.tryParse(item['price'].toString()) ?? 0,
                    status: item['status'],
                    quantity: int.tryParse(item['quantity'].toString()) ?? 0,
                    date: item['created_at'],
                    imageUrl: item['image'],
                  ))
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false; // Stop loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalIncome = reportItems
        .where((item) => item.status == 'Finish' || item.status == 'pending')
        .fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(
        title: Text('REPORT'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
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
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Icon(Icons.error);
              },
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
                  // Text(
                  //   'Status: ${item.status}',
                  //   style: TextStyle(color: statusColor),
                  // ),
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

void main() {
  runApp(MyApp());
}
