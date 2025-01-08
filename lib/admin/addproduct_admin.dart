import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Product',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: AddProductPage(),
    );
  }
}

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDetailController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  void dispose() {
    productNameController.dispose();
    productDetailController.dispose();
    priceController.dispose();
    qtyController.dispose();
    super.dispose();
  }

  Future<void> _uploadImage() async {
    _image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {}); // Update the UI
  }

  Future<void> _saveProduct() async {
    final String name = productNameController.text;
    final String description = productDetailController.text;
    final String price = priceController.text;
    final String stock = qtyController.text;

    if (_image != null) {
      final bytes = await _image!.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse('http://10.0.2.2/beinventori/addproduct_admin.php'),
        body: {
          'name': name,
          'description': description,
          'price': price,
          'stock': stock,
          'image': base64Image,
          'id_category': "6",
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          _showDialog('Product Added', responseData['message']);
        } else {
          _showDialog('Error', responseData['message']);
        }
      } else {
        _showDialog('Error', 'Failed to add product.');
      }
    } else {
      _showDialog('Error', 'Please select an image.');
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
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
        title: Text('Add Product'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _uploadImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        _image != null ? FileImage(File(_image!.path)) : null,
                    child: Text(
                      'UPLOAD\nIMAGE',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Input New Product',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildTextField(productNameController, 'Product Name'),
              SizedBox(height: 16),
              _buildTextField(productDetailController, 'Detail Product',
                  maxLines: 3),
              SizedBox(height: 16),
              _buildTextField(priceController, 'Price',
                  keyboardType: TextInputType.number),
              SizedBox(height: 16),
              _buildTextField(qtyController, 'Qty',
                  keyboardType: TextInputType.number),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveProduct,
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }
}
