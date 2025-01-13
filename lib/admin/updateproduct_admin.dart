import 'package:flutter/material.dart';    
import 'package:http/http.dart' as http;    
import 'dart:convert';    
import 'package:inventori/admin/home_admin.dart'; // Ensure this path is correct    
  
class UpdateProductPage1 extends StatefulWidget {    
  final Product product; // Accept a Product object    
    
  UpdateProductPage1({required this.product}); // Constructor    
    
  @override    
  _UpdateProductPage1State createState() => _UpdateProductPage1State();    
}    
    
class _UpdateProductPage1State extends State<UpdateProductPage1> {    
  final _formKey = GlobalKey<FormState>();    
  late String _name;    
  late String _description;    
  late String _price; // Keep this as String for the TextFormField    
  late String _stock;    
    
  @override    
  void initState() {    
    super.initState();    
    // Initialize fields with the current product data    
    _name = widget.product.name;    
    _description = widget.product.description;    
    _price = widget.product.price.toString(); // Fetch price from the product    
    _stock = widget.product.quantity.toString();    
  }    
    
  Future<void> _updateProduct() async {    
    final response = await http.post(    
      Uri.parse('http://10.0.2.2/beinventori/updateproduct_admin.php'),    
      body: {    
        'id': widget.product.id,    
        'name': _name,    
        'description': _description,    
        'price': _price,    
        'stock': _stock,    
        'id_category': '1', // Adjust as necessary    
      },    
    );    
    
    if (response.statusCode == 200) {    
      final result = json.decode(response.body);    
      if (result['status'] == 'success') {    
        Navigator.pop(context, true); // Return true to indicate success    
      } else {    
        // Handle error    
        ScaffoldMessenger.of(context).showSnackBar(    
          SnackBar(content: Text(result['message'])),    
        );    
      }    
    } else {    
      // Handle server error    
      ScaffoldMessenger.of(context).showSnackBar(    
        SnackBar(content: Text('Failed to update product.')),    
      );    
    }    
  }    
    
  @override    
  Widget build(BuildContext context) {    
    return Scaffold(    
      appBar: AppBar(    
        title: Text('Update Product'),    
        leading: IconButton(    
          icon: Icon(Icons.arrow_back),    
          onPressed: () {    
            Navigator.pop(context); // Action to go back    
          },    
        ),    
      ),    
      body: Padding(    
        padding: const EdgeInsets.all(16.0),    
        child: Form(    
          key: _formKey,    
          child: Column(    
            crossAxisAlignment: CrossAxisAlignment.start,    
            children: [    
              Text('Update Product Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),    
              SizedBox(height: 20),    
              TextFormField(    
                initialValue: _name,    
                decoration: InputDecoration(labelText: 'Product Name'),    
                onSaved: (value) => _name = value ?? '',    
                validator: (value) => value!.isEmpty ? 'Please enter product name' : null,    
              ),    
              TextFormField(    
                initialValue: _description,    
                decoration: InputDecoration(labelText: 'Description'),    
                onSaved: (value) => _description = value ?? '',    
                validator: (value) => value!.isEmpty ? 'Please enter description' : null,    
              ),    
              TextFormField(    
                initialValue: _price,    
                decoration: InputDecoration(labelText: 'Price'),    
                keyboardType: TextInputType.number,    
                onSaved: (value) => _price = value ?? '',    
                validator: (value) => value!.isEmpty ? 'Please enter price' : null,    
              ),    
              TextFormField(    
                initialValue: _stock,    
                decoration: InputDecoration(labelText: 'Stock'),    
                keyboardType: TextInputType.number,    
                onSaved: (value) => _stock = value ?? '',    
                validator: (value) => value!.isEmpty ? 'Please enter stock' : null,    
              ),    
              SizedBox(height: 20),    
              ElevatedButton(    
                onPressed: () {    
                  if (_formKey.currentState!.validate()) {    
                    _formKey.currentState!.save();    
                    _updateProduct();    
                  }    
                },    
                child: Text('Update Product'),    
              ),    
            ],    
          ),    
        ),    
      ),    
    );    
  }    
}  
