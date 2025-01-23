import 'package:flutter/material.dart';  
import 'package:inventori/customer/payment_customer.dart';  
import 'package:inventori/customer/productdetail_customer.dart';  
  
class CartPage extends StatefulWidget {  
  final Product? product; // Add product parameter  
  final int quantity; // Add quantity parameter  
  
  CartPage({this.product, required this.quantity}); // Add quantity parameter  
  
  static List<CartItem> cartItems = []; // Static list to hold cart items  
  
  static void addToCart(Product product, int quantity) {  
    // Method to add product to cart  
    final existingItem = cartItems.where((item) => item.name == product.name).toList();  
  
    if (existingItem.isNotEmpty) {  
      // If the product already exists, add the quantity  
      existingItem.first.quantity += quantity;  
    } else {  
      // If the product does not exist, add it as a new item  
      cartItems.add(CartItem(  
        name: product.name,  
        price: product.price,  
        quantity: quantity,  
        imageUrl: product.imageUrl,  
      ));  
    }  
  }  
  
  @override  
  _CartPageState createState() => _CartPageState();  
}  
  
class _CartPageState extends State<CartPage> {  
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
                itemCount: CartPage.cartItems.length,  
                itemBuilder: (context, index) {  
                  return CartItemWidget(  
                    item: CartPage.cartItems[index],  
                    onIncrement: () => _incrementQuantity(CartPage.cartItems[index]),  
                    onDecrement: () => _decrementQuantity(CartPage.cartItems[index]),  
                  );  
                },  
              ),  
            ),  
            Divider(),  
            Padding(  
              padding: const EdgeInsets.symmetric(vertical: 16.0),  
              child: Text(  
                'Total: IDR ${total.toStringAsFixed(0)}',  
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),  
              ),  
            ),  
            ElevatedButton(  
              onPressed: () {  
                // Action to proceed to payment  
                Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage()));  
              },  
              child: Text('Proceed to Payment'),  
              style: ElevatedButton.styleFrom(  
                padding: EdgeInsets.symmetric(vertical: 16.0),  
                textStyle: TextStyle(fontSize: 18),  
                backgroundColor: Colors.greenAccent,  
                foregroundColor: Colors.black,  
              ),  
            ),  
          ],  
        ),  
      ),  
    );  
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
    return CartPage.cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));  
  }  
}  
  
class CartItem {  
  final String name;  
  final double price;  
  int quantity;  
  final String imageUrl;  
  
  CartItem({  
    required this.name,  
    required this.price,  
    required this.quantity,  
    required this.imageUrl,  
  });  
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
              item.imageUrl,  
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
                  Text('IDR ${item.price.toStringAsFixed(0)}'),  
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
