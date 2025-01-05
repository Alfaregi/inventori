import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  final List<CheckoutItem> checkoutItems = [
    CheckoutItem(
      productName: 'Potensic ATOM SE',
      price: 750000,
      quantity: 1,
      date: '09 Desember 2024',
      status: 'Finished',
      address: 'Jl. Merdeka No. 1, Jakarta',
    ),
    CheckoutItem(
      productName: 'Car Steering Wheel',
      price: 500000,
      quantity: 1,
      date: '10 Desember 2024',
      status: 'Pending',
      address: 'Jl. Sudirman No. 2, Jakarta',
    ),
    CheckoutItem(
      productName: 'Car Mirror',
      price: 300000,
      quantity: 2,
      date: '11 Desember 2024',
      status: 'Finished',
      address: 'Jl. Thamrin No. 3, Jakarta',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout Items'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: checkoutItems.length,
          itemBuilder: (context, index) {
            return CheckoutCard(
              item: checkoutItems[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutDetailPage(item: checkoutItems[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class CheckoutItem {
  final String productName;
  final int price;
  final int quantity;
  final String date;
  final String status;
  final String address;

  CheckoutItem({
    required this.productName,
    required this.price,
    required this.quantity,
    required this.date,
    required this.status,
    required this.address,
  });
}

class CheckoutCard extends StatelessWidget {
  final CheckoutItem item;
  final VoidCallback onTap;

  CheckoutCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(item.productName, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Qty: ${item.quantity} - IDR ${item.price}'),
        trailing: Text(item.status, style: TextStyle(color: item.status == 'Finished' ? Colors.green : Colors.orange)),
        onTap: onTap,
      ),
    );
  }
}

class CheckoutDetailPage extends StatefulWidget {
  final CheckoutItem item;

  CheckoutDetailPage({required this.item});

  @override
  _CheckoutDetailPageState createState() => _CheckoutDetailPageState();
}

class _CheckoutDetailPageState extends State<CheckoutDetailPage> {
  late String currentStatus;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.item.status;
  }

  void _updateStatus() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Status'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  title: Text('Finished'),
                  onTap: () {
                    setState(() {
                      currentStatus = 'Finished';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Delivered'),
                  onTap: () {
                    setState(() {
                      currentStatus = 'Delivered';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Return'),
                  onTap: () {
                    setState(() {
                      currentStatus = 'Return';
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.productName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Name: ${widget.item.productName}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Price: IDR ${widget.item.price}', style: TextStyle(fontSize: 18)),
            Text('Quantity: ${widget.item.quantity}', style: TextStyle(fontSize: 18)),
            Text('Date: ${widget.item.date}', style: TextStyle(fontSize: 18)),
            Text('Status: $currentStatus', style: TextStyle(fontSize: 18)),
            Text('Address: ${widget.item.address}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateStatus,
              child: Text('Change Status'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
