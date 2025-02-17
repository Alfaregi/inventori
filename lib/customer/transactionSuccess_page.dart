import 'package:flutter/material.dart';

class TransactionSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Success'),
      ),
      body: Center(
        child: Text(
          'Your transaction was successful!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
