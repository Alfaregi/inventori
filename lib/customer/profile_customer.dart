import 'package:flutter/material.dart';  
import 'package:inventori/login.dart';  
import 'package:inventori/customer/history.dart';  
import 'package:inventori/customer/faq.dart';  
import 'package:shared_preferences/shared_preferences.dart';  
  
void main() {  
  runApp(MyApp());  
}  
  
class MyApp extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
    return MaterialApp(  
      title: 'Profile Page',  
      theme: ThemeData(  
        primarySwatch: Colors.green,  
      ),  
      home: ProfilePage(),  
    );  
  }  
}  
  
class ProfilePage extends StatefulWidget {  
  @override  
  _ProfilePageState createState() => _ProfilePageState();  
}  
  
class _ProfilePageState extends State<ProfilePage> {  
  String username = '';  
  
  @override  
  void initState() {  
    super.initState();  
    _loadUsername();  
  }  
  
  Future<void> _loadUsername() async {  
    SharedPreferences prefs = await SharedPreferences.getInstance();  
    setState(() {  
      username = prefs.getString('username') ?? 'User'; // Default to 'User' if not found  
    });  
  }  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(  
        title: Text('MY PROFILE'),  
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
          crossAxisAlignment: CrossAxisAlignment.center,  
          children: [  
            CircleAvatar(  
              radius: 50,  
              backgroundColor: Colors.grey[300],  
              child: Icon(Icons.person, size: 50, color: Colors.grey),  
            ),  
            SizedBox(height: 16),  
            Text(  
              'Hi, $username', // Menampilkan nama pengguna  
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),  
            ),  
            Text(  
              'How are you today?',  
              style: TextStyle(fontSize: 16),  
            ),  
            SizedBox(height: 20),  
            Text(  
              'Want to look at your activity?',  
              style: TextStyle(fontSize: 18),  
            ),  
            SizedBox(height: 20),  
            Column(  
              children: [  
                ActivityButton(  
                  label: 'HISTORY',  
                  onPressed: () {  
                    Navigator.push(  
                      context,  
                      MaterialPageRoute(builder: (context) => HistoryPage()),  
                    );  
                  },  
                ),  
                ActivityButton(  
                  label: 'FAQ',  
                  onPressed: () {  
                    Navigator.push(  
                      context,  
                      MaterialPageRoute(builder: (context) => FAQPage()),  
                    );  
                  },  
                ),  
                ActivityButton(  
                  label: 'Logout',  
                  onPressed: () {  
                    showDialog(  
                      context: context,  
                      builder: (context) {  
                        return AlertDialog(  
                          title: Text('Logout'),  
                          content: Text('Are you sure you want to logout?'),  
                          actions: [  
                            TextButton(  
                              onPressed: () {  
                                Navigator.of(context).pop(); // Tutup dialog  
                              },  
                              child: Text('Cancel'),  
                            ),  
                            TextButton(  
                              onPressed: () {  
                                // Logika untuk logout  
                                Navigator.of(context).pop(); // Tutup dialog  
                                _logout(); // Panggil fungsi logout  
                              },  
                              child: Text('Logout'),  
                            ),  
                          ],  
                        );  
                      },  
                    );  
                  },  
                ),  
              ],  
            ),  
          ],  
        ),  
      ),  
    );  
  }  
  
  Future<void> _logout() async {  
    SharedPreferences prefs = await SharedPreferences.getInstance();  
    await prefs.remove('username'); // Hapus username dari SharedPreferences  
    Navigator.pushReplacement(  
      context,  
      MaterialPageRoute(builder: (context) => LoginPage()),  
    ); // Navigasi ke halaman login  
  }  
}  
  
class ActivityButton extends StatelessWidget {  
  final String label;  
  final VoidCallback onPressed;  
  
  ActivityButton({required this.label, required this.onPressed});  
  
  @override  
  Widget build(BuildContext context) {  
    return Container(  
      width: double.infinity,  
      margin: EdgeInsets.symmetric(vertical: 8.0),  
      child: ElevatedButton(  
        onPressed: onPressed,  
        child: Text(label),  
        style: ElevatedButton.styleFrom(  
          backgroundColor: Colors.green, // Warna latar belakang tombol  
          padding: EdgeInsets.symmetric(vertical: 16.0),  
          textStyle: TextStyle(fontSize: 18),  
        ),  
      ),  
    );  
  }  
}  
