import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cart_customer.dart'; // Import cart page
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController addressController = TextEditingController();

  Future<void> initiatePayment() async {
    final String url =
        'http://10.0.2.2/beinventori/payment.php'; // Ganti dengan URL server Anda

    // Ambil item keranjang dari CartPage
    List<CartItem> cartItems = CartPage.cartItems;

    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Keranjang Anda kosong!')),
      );
      return;
    }

    // Validasi setiap item untuk memastikan ada product_id
    for (var item in cartItems) {
      if (item.product_id == null || item.product_id.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product ID diperlukan untuk setiap item!')),
        );
        return;
      }
    }

    double total =
        cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    int userId = 1; // Ganti dengan user ID yang sesuai

    final Map<String, dynamic> paymentData = {
      'order_id':
          'order-${DateTime.now().millisecondsSinceEpoch}', // ID pesanan unik
      'gross_amount': total,
      'items': cartItems
          .map((item) => {
                'product_id': item.product_id,
                'name': item.name,
                'price': item.price,
                'quantity': item.quantity,
              })
          .toList(),
      'address': addressController.text,
      'username': 'rezi', // Ganti dengan username yang sesuai
      'user_id': userId,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(paymentData),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData.containsKey('snap_token')) {
        // Mulai proses pembayaran dengan Midtrans
        await startMidtransPayment(responseData['snap_token']);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Pembayaran gagal: snap_token tidak ditemukan di response')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pembayaran gagal: ${response.body}')),
      );
    }
  }

  Future<void> startMidtransPayment(String snapToken) async {
    final Uri paymentUrl =
        Uri.parse('https://app.sandbox.midtrans.com/snap/v2/vtweb/$snapToken');

    if (!await launchUrl(paymentUrl, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $paymentUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<CartItem> cartItems = CartPage.cartItems;
    double total =
        cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Scaffold(
      appBar: AppBar(
        title: Text('Opsi Pembayaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pesanan Anda',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.network(cartItems[index].imageUrl,
                        width: 50, height: 50),
                    title: Text(cartItems[index].name),
                    subtitle: Text(
                        'IDR ${cartItems[index].price.toStringAsFixed(0)}'),
                    trailing: Text('Qty: ${cartItems[index].quantity}'),
                  );
                },
              ),
            ),
            Divider(),
            Text('Nama + Alamat Pengiriman:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Masukkan Nama dan alamat Anda',
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text('Total: IDR ${total.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: initiatePayment,
              child: Text('Bayar'),
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





// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'cart_customer.dart'; // Import cart page

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Payment Options',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//       ),
//       home: PaymentPage(),
//     );
//   }
// }

// class PaymentPage extends StatefulWidget {
//   @override
//   _PaymentPageState createState() => _PaymentPageState();
// }

// class _PaymentPageState extends State<PaymentPage> {
//   final TextEditingController addressController = TextEditingController();

//   Future<void> initiatePayment() async {
//     final String url =
//         'http://10.0.2.2/beinventori/payment.php'; // Ganti dengan URL server Anda

//     // Ambil item keranjang dari CartPage
//     List<CartItem> cartItems = CartPage.cartItems;

//     if (cartItems.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Your cart is empty!')),
//       );
//       return;
//     }

//     // Validasi setiap item untuk memastikan ada product_id
//     for (var item in cartItems) {
//       if (item.product_id == null || item.product_id.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Product ID is required for each item!')),
//         );
//         return;
//       }
//     }

//     double total =
//         cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

//     // Ganti userId dengan ID pengguna yang sesuai
//     int userId = 1; // Ganti dengan ID pengguna yang sesuai

//     final Map<String, dynamic> paymentData = {
//       'order_id':
//           'order-${DateTime.now().millisecondsSinceEpoch}', // Unique order ID
//       'gross_amount': total,
//       'items': cartItems
//           .map((item) => {
//                 'product_id': item.product_id, // product_id
//                 'name': item.name,
//                 'price': item.price,
//                 'quantity': item.quantity,
//               })
//           .toList(),
//       'address': addressController.text,
//       'username': 'murod', // Ganti dengan username yang sesuai
//       'user_id': userId, // Kirim ID pengguna yang sesuai
//     };

//     final response = await http.post(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(paymentData),
//     );

//     // Debugging
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');

//     if (response.statusCode == 200) {
//       final responseData = json.decode(response.body);
//       // Tangani respons dari Midtrans
//       print('Payment Response: $responseData');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Payment initiated successfully!')),
//       );
//     } else {
//       // Tangani kesalahan
//       print('Error: ${response.body}');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Payment failed: ${response.body}')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<CartItem> cartItems = CartPage.cartItems;

//     double total =
//         cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Payment Options'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Your Order',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: cartItems.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     leading: Image.network(
//                       cartItems[index].imageUrl,
//                       width: 50,
//                       height: 50,
//                     ),
//                     title: Text(cartItems[index].name),
//                     subtitle: Text(
//                         'IDR ${cartItems[index].price.toStringAsFixed(0)}'),
//                     trailing: Text('Qty: ${cartItems[index].quantity}'),
//                   );
//                 },
//               ),
//             ),
//             Divider(),
//             Text(
//               'Shipping Address:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             TextField(
//               controller: addressController,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Enter your address',
//               ),
//             ),
//             SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16.0),
//               child: Text(
//                 'Total: IDR ${total.toStringAsFixed(0)}',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 initiatePayment(); // Panggil fungsi untuk memulai pembayaran
//               },
//               child: Text('Pay'),
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(vertical: 16.0),
//                 textStyle: TextStyle(fontSize: 18),
//                 backgroundColor: Colors.greenAccent,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
