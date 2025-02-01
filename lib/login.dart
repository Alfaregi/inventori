import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventori/admin/home_admin.dart';
import 'package:inventori/customer/home_customer.dart';
import 'package:inventori/owner/home_owner.dart';
import 'package:inventori/register.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/beinventori/login.php'),
      body: {
        'username': usernameController.text,
        'password': passwordController.text,
      },
    );

    final data = json.decode(response.body);
    if (data['status'] == 'success') {
      // Simpan nama pengguna di SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', usernameController.text);

      if (data['role'] == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
      } else if (data['role'] == 'owner') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OwnerHomePage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } else {
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
            Text(
              'DKI JAYA STORE',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'USERNAME',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
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
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => login(context),
              child: Text('LOGIN'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Aksi untuk mengarahkan ke halaman registrasi
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text(
                'Don\'t Have Account? Register here!',
                style: TextStyle(
                    color: Colors.white, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
