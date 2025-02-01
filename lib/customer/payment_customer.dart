import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cart_customer.dart'; // Import cart page

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment Options',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: PaymentPage(),
    );
  }
}

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController addressController = TextEditingController();

  Future<void> initiatePayment() async {
    final String url =
        'http://10.0.2.2/beinventori/payment.php'; // Replace with your server URL

    // Retrieve cart items from the static list in CartPage
    List<CartItem> cartItems = CartPage.cartItems;

    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your cart is empty!')),
      );
      return;
    }

    double total =
        cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    final Map<String, dynamic> paymentData = {
      'order_id':
          'order-${DateTime.now().millisecondsSinceEpoch}', // Unique order ID
      'gross_amount': total,
      'items': cartItems
          .map((item) => {
                'id': item.id, // Ensure this is a unique identifier
                'name': item.name,
                'price': item.price,
                'quantity': item.quantity,
              })
          .toList(),
      'address': addressController.text,
      'username': 'rezi', // Add the username here
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(paymentData),
    );

    // Print the raw response for debugging
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // Handle the response from Midtrans
      print('Payment Response: $responseData');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment initiated successfully!')),
      );
    } else {
      // Handle error
      print('Error: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve cart items from the static list in CartPage
    List<CartItem> cartItems = CartPage.cartItems;

    double total =
        cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Options'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Order',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.network(
                      cartItems[index]
                          .imageUrl, // Use the imageUrl from CartItem
                      width: 50,
                      height: 50,
                    ),
                    title: Text(cartItems[index].name),
                    subtitle: Text(
                        'IDR ${cartItems[index].price.toStringAsFixed(0)}'),
                    trailing: Text('Qty: ${cartItems[index].quantity}'),
                  );
                },
              ),
            ),
            Divider(),
            Text(
              'Shipping Address:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your address',
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Total: IDR ${total.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                initiatePayment(); // Call the payment initiation function
              },
              child: Text('Pay'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 18),
                backgroundColor: Colors.greenAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
