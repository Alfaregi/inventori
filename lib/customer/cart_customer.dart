import 'package:flutter/material.dart';  
import 'package:inventori/customer/payment_customer.dart';  
import 'package:inventori/customer/productdetail_customer.dart';  
  
class MyApp extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
    return MaterialApp(  
      title: 'Cart Page',  
      theme: ThemeData(  
        primarySwatch: Colors.green,  
      ),  
      home: CartPage(),  
    );  
  }  
}  
  
class CartPage extends StatefulWidget {  
  final Product? product; // Tambahkan parameter product  
  
  CartPage({this.product}); // Tambahkan parameter product  
  
  @override  
  _CartPageState createState() => _CartPageState();  
}  
  
class _CartPageState extends State<CartPage> {  
  List<CartItem> cartItems = [];  
  
  @override  
  void initState() {  
    super.initState();  
    if (widget.product != null) {  
      // Jika ada produk yang dikirim, tambahkan ke keranjang  
      _addToCart(widget.product!);  
    }  
  }  
  
  void _addToCart(Product product) {  
  setState(() {  
    // Cek apakah produk sudah ada di keranjang  
    final existingItem = cartItems.where((item) => item.name == product.name).toList();  
  
    if (existingItem.isNotEmpty) {  
      // Jika produk sudah ada, tambahkan jumlahnya  
      existingItem.first.quantity++;  
    } else {  
      // Jika produk belum ada, tambahkan sebagai item baru  
      cartItems.add(CartItem(name: product.name, price: product.price, quantity: 1));  
    }  
  });  
}  
 
  
  void _incrementQuantity(CartItem item) {  
    setState(() {  
      item.quantity++;  
    });  
  }  
  
  void _decrementQuantity(CartItem item) {  
    setState(() {  
      if (item.quantity > 1) {  
        item.quantity--;  
      }  
    });  
  }  
  
  double get total {  
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));  
  }  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        title: Text('Cart'),  
      ),  
      body: Padding(  
        padding: const EdgeInsets.all(16.0),  
        child: Column(  
          crossAxisAlignment: CrossAxisAlignment.start,  
          children: [  
            Text(  
              'Your Cart',  
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),  
            ),  
            SizedBox(height: 16),  
            Expanded(  
              child: ListView.builder(  
                itemCount: cartItems.length,  
                itemBuilder: (context, index) {  
                  return CartItemWidget(  
                    item: cartItems[index],  
                    onIncrement: () => _incrementQuantity(cartItems[index]),  
                    onDecrement: () => _decrementQuantity(cartItems[index]),  
                  );  
                },  
              ),  
            ),  
            Divider(),  
            Padding(  
              padding: const EdgeInsets.symmetric(vertical: 16.0),  
              child: Text(  
                'Total: IDR${total.toStringAsFixed(0)}',  
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),  
              ),  
            ),  
            ElevatedButton(  
              onPressed: () {  
                // Aksi untuk melanjutkan ke pembayaran  
                Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage()));  
              },  
              child: Text('Proceed to Payment'),  
              style: ElevatedButton.styleFrom(  
                padding: EdgeInsets.symmetric(vertical: 16.0),  
                textStyle: TextStyle(fontSize: 18),  
                backgroundColor: Colors.greenAccent,  
                foregroundColor: Colors.black, // Mengatur warna teks menjadi hitam  
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
  
class CartItemWidget extends StatelessWidget {  
  final CartItem item;  
  final VoidCallback onIncrement;  
  final VoidCallback onDecrement;  
  
  CartItemWidget({  
    required this.item,  
    required this.onIncrement,  
    required this.onDecrement,  
  });  
  
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
              'https://via.placeholder.com/100', // Ganti dengan URL gambar produk  
              width: 100,  
              height: 100,  
            ),  
            SizedBox(width: 16),  
            Expanded(  
              child: Column(  
                crossAxisAlignment: CrossAxisAlignment.start,  
                children: [  
                  Text(  
                    item.name,  
                    style: TextStyle(fontWeight: FontWeight.bold),  
                  ),  
                  Text('IDR${item.price.toStringAsFixed(0)}'),  
                ],  
              ),  
            ),  
            Column(  
              children: [  
                IconButton(  
                  icon: Icon(Icons.remove),  
                  onPressed: onDecrement,  
                ),  
                Text('${item.quantity}'),  
                IconButton(  
                  icon: Icon(Icons.add),  
                  onPressed: onIncrement,  
                ),  
              ],  
            ),  
          ],  
        ),  
      ),  
    );  
  }  
}  
