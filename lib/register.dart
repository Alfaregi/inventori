import 'package:flutter/material.dart';  
import 'package:http/http.dart' as http;  
import 'dart:convert';  
import 'login.dart';  
  
class RegisterPage extends StatelessWidget {  
  final TextEditingController nameController = TextEditingController();  
  final TextEditingController usernameController = TextEditingController();  
  final TextEditingController passwordController = TextEditingController();  
  
  Future<void> register(BuildContext context) async {  
    final response = await http.post(  
      Uri.parse('http://10.0.2.2/beinventori/register.php'),  
      body: {  
        'name': nameController.text,  
        'username': usernameController.text,  
        'password': passwordController.text,  
      },  
    );  
  
    final data = json.decode(response.body);  
    if (data['status'] == 'success') {  
      // Navigate to login page after successful registration  
      Navigator.pushReplacement(  
        context,  
        MaterialPageRoute(builder: (context) => LoginPage()),  
      );  
    } else {  
      // Show error message  
      ScaffoldMessenger.of(context).showSnackBar(  
        SnackBar(content: Text(data['message'])),  
      );  
    }  
  }  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      body: Container(  
        color: Colors.blue,  
        padding: const EdgeInsets.all(16.0),  
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.center,  
          children: [  
            Icon(Icons.shopping_cart, size: 100, color: Colors.white),  
            SizedBox(height: 20),  
            Text('DKI JAYA STORE', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),  
            SizedBox(height: 40),  
            TextField(  
              controller: nameController,  
              decoration: InputDecoration(  
                filled: true,  
                fillColor: Colors.white,  
                hintText: 'NAME',  
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),  
              ),  
            ),  
            SizedBox(height: 16),  
            TextField(  
              controller: usernameController,  
              decoration: InputDecoration(  
                filled: true,  
                fillColor: Colors.white,  
                hintText: 'USERNAME',  
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),  
              ),  
            ),  
            SizedBox(height: 16),  
            TextField(  
              controller: passwordController,  
              obscureText: true,  
              decoration: InputDecoration(  
                filled: true,  
                fillColor: Colors.white,  
                hintText: 'PASSWORD',  
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),  
              ),  
            ),  
            SizedBox(height: 20),  
            ElevatedButton(  
              onPressed: () => register(context),  
              child: Text('REGISTER'),  
              style: ElevatedButton.styleFrom(  
                foregroundColor: Colors.blue,  
                backgroundColor: Colors.white,  
                padding: EdgeInsets.symmetric(vertical: 16.0),  
                textStyle: TextStyle(fontSize: 18),  
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),  
              ),  
            ),  
            SizedBox(height: 20),  
            GestureDetector(  
              onTap: () {  
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));  
              },  
              child: Text('Already Have Account? Login here!', style: TextStyle(color: Colors.white, decoration: TextDecoration.underline)),  
            ),  
          ],  
        ),  
      ),  
    );  
  }  
}  
