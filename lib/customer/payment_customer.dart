import 'package:flutter/material.dart';

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
  int selectedPaymentMethod = 0; // Menyimpan metode pembayaran yang dipilih

  List<CartItem> cartItems = [
    CartItem(name: 'Potensic ATOM SE GPS Drone', price: 229, quantity: 1),
  ];

  double get total {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                      'https://via.placeholder.com/100', // Ganti dengan URL gambar produk
                      width: 50,
                      height: 50,
                    ),
                    title: Text(cartItems[index].name),
                    subtitle: Text('\$${cartItems[index].price.toStringAsFixed(2)}'),
                    trailing: Text('Qty: ${cartItems[index].quantity}'),
                  );
                },
              ),
            ),
            Divider(),
            // Form Alamat
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
                'Sub Total: \$${total.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              'Payment Method:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text('Credit / Debit'),
              leading: Radio(
                value: 0,
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value as int;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Paypal'),
              leading: Radio(
                value: 1,
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value as int;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Qiwi'),
              leading: Radio(
                value: 2,
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value as int;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Bitcoin'),
              leading: Radio(
                value: 3,
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value as int;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Stripe'),
              leading: Radio(
                value: 4,
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value as int;
                  });
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Total: \$${total.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Aksi untuk menyelesaikan pembayaran
                // Anda bisa menggunakan addressController.text untuk mendapatkan alamat
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

class CartItem {
  final String name;
  final double price;
  int quantity;

  CartItem({required this.name, required this.price, required this.quantity});
}
