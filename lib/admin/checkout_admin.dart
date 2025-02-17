import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<CheckoutItem> checkoutItems = [];
  List<CheckoutItem> filteredItems = [];
  bool isLoading = true;
  String errorMessage = '';
  String searchQuery = '';
  String selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2/beinventori/history.php'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          checkoutItems =
              data.map((item) => CheckoutItem.fromJson(item)).toList();
          filteredItems = checkoutItems;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> updateStatus(String newStatus, int index) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/beinventori/update_status.php'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'status': newStatus,
          'user_id': checkoutItems[index].userId,
          'product_id': checkoutItems[index].productId,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          checkoutItems[index].status = newStatus;
          filterItems();
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('Status updated to $newStatus'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        throw Exception('Failed to update status');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    }
  }

  void filterItems() {
    setState(() {
      filteredItems = checkoutItems.where((item) {
        bool matchesStatus =
            selectedStatus == 'All' || item.status == selectedStatus;
        bool matchesSearch = searchQuery.isEmpty ||
            item.productName
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            item.date.contains(searchQuery) ||
            item.quantity.toString().contains(searchQuery);
        return matchesStatus && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout Items'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by name, date, qty...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                        filterItems();
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedStatus,
                  items: ['All', 'pending', 'Delivered', 'Finished']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                      filterItems();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                    ? Center(child: Text(errorMessage))
                    : ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          return CheckoutCard(
                            item: filteredItems[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutDetailPage(
                                    item: filteredItems[index],
                                    onStatusChange: (newStatus) {
                                      setState(() {
                                        filteredItems[index].status = newStatus;
                                        filterItems();
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class CheckoutItem {
  String productName;
  int price;
  int quantity;
  String date;
  String status;
  String address;
  int userId;
  int productId;

  CheckoutItem({
    required this.productName,
    required this.price,
    required this.quantity,
    required this.date,
    required this.status,
    required this.address,
    required this.userId,
    required this.productId,
  });

  factory CheckoutItem.fromJson(Map<String, dynamic> json) {
    return CheckoutItem(
      productName: json['name'] as String,
      price: int.tryParse(json['price'].toString()) ?? 0,
      quantity: int.tryParse(json['quantity'].toString()) ?? 0,
      date: json['created_at'] as String,
      status: json['status'] as String,
      address: json['address'] as String,
      userId: json['user_id'] ?? 0,
      productId: json['product_id'] ?? 0,
    );
  }
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
        title: Text(item.productName,
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Qty: ${item.quantity} - IDR ${item.price}'),
            Text('Date: ${item.date}'),
          ],
        ),
        trailing: Text(
          item.status,
          style: TextStyle(
            color: item.status == 'Finished' ? Colors.green : Colors.orange,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class CheckoutDetailPage extends StatefulWidget {
  final CheckoutItem item;
  final Function(String) onStatusChange;

  CheckoutDetailPage({required this.item, required this.onStatusChange});

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
                  title: Text('Pending'),
                  onTap: () {
                    setState(() {
                      currentStatus = 'Pending';
                    });
                    widget.onStatusChange('Pending');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Delivered'),
                  onTap: () {
                    setState(() {
                      currentStatus = 'Delivered';
                    });
                    widget.onStatusChange('Delivered');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Finished'),
                  onTap: () {
                    setState(() {
                      currentStatus = 'Finished';
                    });
                    widget.onStatusChange('Finished');
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
            Text('Price: IDR ${widget.item.price}',
                style: TextStyle(fontSize: 18)),
            Text('Quantity: ${widget.item.quantity}',
                style: TextStyle(fontSize: 18)),
            Text('Date: ${widget.item.date}', style: TextStyle(fontSize: 18)),
            Text('Status: $currentStatus', style: TextStyle(fontSize: 18)),
            Text('Address: ${widget.item.address}',
                style: TextStyle(fontSize: 18)),
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
