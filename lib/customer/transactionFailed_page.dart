import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionFailedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Failed'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              size: 100,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              'Transaction Failed!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            SizedBox(height: 10),
            Text(
              'Please try again later.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.back(); // Navigate back to the previous page
              },
              child: Text('Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
