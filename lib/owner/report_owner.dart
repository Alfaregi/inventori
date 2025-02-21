// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Report Page',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//       ),
//       home: OwnerReportPage(),
//     );
//   }
// }

// class OwnerReportPage extends StatefulWidget {
//   @override
//   _OwnerReportPageState createState() => _OwnerReportPageState();
// }

// class _OwnerReportPageState extends State<OwnerReportPage> {
//   List<ReportItem> reportItems = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     try {
//       final response =
//           await http.get(Uri.parse('http://10.0.2.2/beinventori/history.php'));

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         setState(() {
//           reportItems = data
//               .map((item) => ReportItem(
//                     productName: item['name'],
//                     price: int.tryParse(item['price'].toString()) ?? 0,
//                     status: item['status'],
//                     quantity: int.tryParse(item['quantity'].toString()) ?? 0,
//                     date: item['created_at'],
//                     imageUrl: item['image'],
//                   ))
//               .toList();
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load data: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//       setState(() {
//         isLoading = false; // Stop loading indicator
//       });
//     }
//   }

//   void _showOutcomeForm(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return OutcomeForm();
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     int totalIncome = reportItems
//         .where((item) => item.status == 'Finish' || item.status == 'pending')
//         .fold(0, (sum, item) => sum + item.price);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('REPORT'),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(18.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Your Income',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'IDR +$totalIncome',
//                     style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       _showOutcomeForm(context);
//                     },
//                     child: Text('Add Outcome'),
//                   ),
//                   SizedBox(height: 20),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: reportItems.length,
//                       itemBuilder: (context, index) {
//                         return ReportCard(item: reportItems[index]);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

// class OutcomeForm extends StatefulWidget {
//   @override
//   _OutcomeFormState createState() => _OutcomeFormState();
// }

// class _OutcomeFormState extends State<OutcomeForm> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _productNameController = TextEditingController();
//   final TextEditingController _quantityController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();

//   void _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       final String productName = _productNameController.text;
//       final int quantity = int.tryParse(_quantityController.text) ?? 0;
//       final int price = int.tryParse(_priceController.text) ?? 0;

//       final response = await http.post(
//         Uri.parse('http://10.0.2.2/beinventori/outcome.php'),
//         body: {
//           'productName': productName,
//           'quantity': quantity.toString(),
//           'price': price.toString(),
//         },
//       );

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Outcome added successfully!')),
//         );
//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to add outcome')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       child: Form(
//         key: _formKey,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextFormField(
//                 controller: _productNameController,
//                 decoration: InputDecoration(labelText: 'Product Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter product name';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _quantityController,
//                 decoration: InputDecoration(labelText: 'Quantity'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter quantity';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _priceController,
//                 decoration: InputDecoration(labelText: 'Price'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter price';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: Text('Submit'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ReportItem {
//   final String productName;
//   final int price;
//   final String status;
//   final int quantity;
//   final String date;
//   final String imageUrl;

//   ReportItem({
//     required this.productName,
//     required this.price,
//     required this.status,
//     required this.quantity,
//     required this.date,
//     required this.imageUrl,
//   });
// }

// class ReportCard extends StatelessWidget {
//   final ReportItem item;

//   ReportCard({required this.item});

//   @override
//   Widget build(BuildContext context) {
//     Color statusColor = item.status == 'Finish' ? Colors.green : Colors.red;

//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8.0),
//       child: Padding(
//         padding: const EdgeInsets.all(18.0),
//         child: Row(
//           children: [
//             Image.network(
//               item.imageUrl,
//               width: 80,
//               height: 80,
//               fit: BoxFit.cover,
//               loadingBuilder: (BuildContext context, Widget child,
//                   ImageChunkEvent? loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return Center(
//                   child: CircularProgressIndicator(
//                     value: loadingProgress.expectedTotalBytes != null
//                         ? loadingProgress.cumulativeBytesLoaded /
//                             loadingProgress.expectedTotalBytes!
//                         : null,
//                   ),
//                 );
//               },
//               errorBuilder: (BuildContext context, Object exception,
//                   StackTrace? stackTrace) {
//                 return Icon(Icons.error);
//               },
//             ),
//             SizedBox(width: 18),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     item.productName,
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text('IDR ${item.price}'),
//                   Text('Qty: ${item.quantity}'),
//                   Text(item.date),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MyApp());
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Report Page',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: OwnerReportPage(),
    );
  }
}

class OwnerReportPage extends StatefulWidget {
  @override
  _OwnerReportPageState createState() => _OwnerReportPageState();
}

class _OwnerReportPageState extends State<OwnerReportPage> {
  List<ReportItem> reportItems = [];
  List<OutcomeItem> outcomeItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchOutcomeData(); // Fetch outcome data
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2/beinventori/history.php'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          reportItems = data
              .map((item) => ReportItem(
                    productName: item['name'],
                    price: int.tryParse(item['price'].toString()) ?? 0,
                    status: item['status'],
                    quantity: int.tryParse(item['quantity'].toString()) ?? 0,
                    date: item['created_at'],
                    imageUrl: item['image'],
                  ))
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false; // Stop loading indicator
      });
    }
  }

  Future<void> fetchOutcomeData() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2/beinventori/outcome.php'));
      print('Raw response: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);

        // Check if the response is a List or a Map
        if (decodedResponse['status'] == 'success') {
          final List<dynamic> data = decodedResponse['data'];
          setState(() {
            outcomeItems = data
                .map((item) => OutcomeItem(
                      productName: item['productName'],
                      price: int.tryParse(item['price'].toString()) ?? 0,
                      quantity: int.tryParse(item['quantity'].toString()) ?? 0,
                    ))
                .toList();
          });
        } else {
          print('Error from server: ${decodedResponse['message']}');
        }
      } else {
        throw Exception('Failed to load outcome data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching outcome data: $e');
    }
  }

  void _showOutcomeForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return OutcomeForm();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalIncome = reportItems
        .where((item) => item.status == 'Finish' || item.status == 'pending')
        .fold(0, (sum, item) => sum + item.price);

    int totalOutcome = outcomeItems.fold(0, (sum, item) => sum + item.price);

    // Calculate profit
    int profit = totalIncome - totalOutcome;

    return Scaffold(
      appBar: AppBar(
        title: Text('REPORT'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Income',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'IDR +$totalIncome',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  Text(
                    'Your Outcome',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'IDR -$totalOutcome',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your Profit',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'IDR $profit', // Display the profit
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: profit >= 0 ? Colors.green : Colors.red),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showOutcomeForm(context);
                    },
                    child: Text('Add Outcome'),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: reportItems.length,
                      itemBuilder: (context, index) {
                        return ReportCard(item: reportItems[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class OutcomeForm extends StatefulWidget {
  @override
  _OutcomeFormState createState() => _OutcomeFormState();
}

class _OutcomeFormState extends State<OutcomeForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String productName = _productNameController.text;
      final int quantity = int.tryParse(_quantityController.text) ?? 0;
      final int price = int.tryParse(_priceController.text) ?? 0;

      final response = await http.post(
        Uri.parse('http://10.0.2.2/beinventori/outcome.php'),
        body: {
          'productName': productName,
          'quantity': quantity.toString(),
          'price': price.toString(),
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Outcome added successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add outcome')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportItem {
  final String productName;
  final int price;
  final String status;
  final int quantity;
  final String date;
  final String imageUrl;

  ReportItem({
    required this.productName,
    required this.price,
    required this.status,
    required this.quantity,
    required this.date,
    required this.imageUrl,
  });
}

class OutcomeItem {
  final String productName;
  final int price;
  final int quantity;

  OutcomeItem({
    required this.productName,
    required this.price,
    required this.quantity,
  });
}

class ReportCard extends StatelessWidget {
  final ReportItem item;

  ReportCard({required this.item});

  @override
  Widget build(BuildContext context) {
    Color statusColor = item.status == 'Finish' ? Colors.green : Colors.red;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            Image.network(
              item.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Icon(Icons.error);
              },
            ),
            SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('IDR ${item.price}'),
                  Text('Qty: ${item.quantity}'),
                  Text(item.date),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
