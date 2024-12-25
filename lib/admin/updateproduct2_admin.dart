import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Update Product',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: UpdateProductPage2(),
    );
  }
}

class UpdateProductPage2 extends StatefulWidget {
  @override
  _UpdateProductPageState createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage2> {
  final Product product = Product(
    name: 'Potensic ATOM SE GPS Drone',
    price: 750000,
    description: 'Potensic ATOM SE GPS Drone with 4K EIS Camera, Under 249g, 62 Mins Flight, 4KM FPV Transmission, Brushless Motor, Max Speed 16m/s, Auto Return, Lightweight and Foldable Drone for Adults, Beginner',
    quantity: 12,
    imageUrl: 'https://via.placeholder.com/150',
  );

  late TextEditingController priceController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    priceController = TextEditingController(text: product.price.toString());
    descriptionController = TextEditingController(text: product.description);
  }

  @override
  void dispose() {
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _increaseQuantity() {
    setState(() {
      product.quantity++;
    });
  }

  void _decreaseQuantity() {
    setState(() {
      if (product.quantity > 0) {
        product.quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Product'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Aksi untuk kembali
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.imageUrl, width: double.infinity, height: 150, fit: BoxFit.cover),
            SizedBox(height: 16),
            Text(
              'Price',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter price',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Product Detail',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter product description',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Qty: ${product.quantity}',
              style: TextStyle(fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _decreaseQuantity,
                  child: Text('-'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
                ElevatedButton(
                  onPressed: _increaseQuantity,
                  child: Text('+'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ],
            ),
            Spacer(), // Mengisi ruang yang tersisa
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Aksi untuk membatalkan
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Aksi untuk menyimpan perubahan
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Product Updated'),
                          content: Text('The product has been updated successfully.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Tutup dialog
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final int price;
  final String description;
  int quantity; // Ubah menjadi int agar bisa diubah
  final String imageUrl;

  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.quantity,
    required this.imageUrl,
  });
}
