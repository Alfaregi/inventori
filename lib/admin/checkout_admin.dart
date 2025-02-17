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
    try {
      print('Fetching data...');
      final response =
          await http.get(Uri.parse('http://10.0.2.2/beinventori/history.php'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // Log the response body

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          checkoutItems = data.map((item) {
            return CheckoutItem(
              productName: item['name'] as String,
              price: int.tryParse(item['price'].toString()) ??
                  0, // Default to 0 if null
              quantity: int.tryParse(item['quantity'].toString()) ??
                  0, // Default to 0 if null
              date: item['created_at'] as String,
              status: item['status'] as String,
              address: item['address'] ?? 'Address not provided',
              userId: item['user_id'] ?? 0, // Ensure userId is provided
              productId:
                  item['product_id'] ?? 0, // Ensure productId is provided
            );
          }).toList();
          isLoading = false; // Set loading to false after data is fetched
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data';
          isLoading = false; // Set loading to false on error
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false; // Set loading to false on exception
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
          'user_id': checkoutItems[index]
              .userId, // Ensure you have userId in your CheckoutItem
          'product_id': checkoutItems[index]
              .productId, // Ensure you have productId in your CheckoutItem
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          // checkoutItems[index].status = newStatus; // Update the status locally
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
  int userId; // Add this
  int productId; // Add this

  CheckoutItem({
    required this.productName,
    required this.price,
    required this.quantity,
    required this.date,
    required this.status,
    required this.address,
    required this.userId, // Add this
    required this.productId, // Add this
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
        title: Text(item.productName,
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Qty: ${item.quantity} - IDR ${item.price}'),
            Text(
                'Date: ${item.date}'), // Menampilkan tanggal di bawah harga dan qty
          ],
        ),
        trailing: Text(item.status,
            style: TextStyle(
                color:
                    item.status == 'Finished' ? Colors.green : Colors.orange)),
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
            Text('Product Name: ${widget.item.productName}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
