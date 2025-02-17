import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionExpiredPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Expired'),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timer_off,
              size: 100,
              color: Colors.pink,
            ),
            SizedBox(height: 20),
            Text(
              'Transaction Expired!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink),
            ),
            SizedBox(height: 10),
            Text(
              'The transaction has expired. Please try again.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.back(); // Navigate back to the previous page
              },
              child: Text('Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
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
