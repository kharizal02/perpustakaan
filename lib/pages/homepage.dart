import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:e_libs/user/buku.dart';
import 'package:e_libs/user/list_peminjaman.dart';
import 'package:e_libs/util/config/config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Libs',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          displayLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900),
          displayMedium: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900),
          bodyLarge: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.blue.shade800),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  final int initialIndex;

  HomePage({this.initialIndex = 0});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String _username = '';

  Future<void> _getUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Ambil username
      String username = prefs.getString('nama') ?? 'User';
      print('Username dari SharedPreferences: $username'); // Debugging

      // Set ke state
      setState(() {
        _username = username;
      });

      // Ambil notifikasi
      String? notifikasiData = prefs.getString('notifikasi');
      print('Notifikasi dari SharedPreferences: $notifikasiData'); // Debugging

      // Parse notifikasi jika ada
      if (notifikasiData != null && notifikasiData.isNotEmpty) {
        try {
          List<dynamic> notifikasiList = json.decode(notifikasiData);
          print('Parsed Notifikasi: $notifikasiList'); // Debugging
          if (notifikasiList.isNotEmpty) {
            _showNotifikasiDialog(notifikasiList);
            // Tandai bahwa notifikasi sudah dilihat
            prefs.setBool('has_seen_notification', true);
          }
        } catch (e) {
          print('Error parsing notifikasi: $e');
        }
      }
    } catch (e) {
      print('Error getting user data: $e'); // Debugging
    }
  }

  Future<void> _deleteNotifikasi(String idNotifikasi) async {
    try {
      var uri = Uri.http(
          AppConfig.API_HOST, '/perpustakaan/booking/delete_notifikasi.php');

      final response = await http.post(
        uri,
        body: {
          'id_notifikasi': idNotifikasi,
        },
      );

      final jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 'success') {
        print('Notifikasi berhasil dihapus');
      } else {
        print('Gagal menghapus notifikasi: ${jsonResponse['message']}');
      }
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  void _showNotifikasiDialog(List notifikasi) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Notifikasi',
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: notifikasi
                .where((notif) => notif != null && notif is Map)
                .map<Widget>((notif) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue[50],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.notifications_active,
                    color: Colors.blue,
                    size: 30,
                  ),
                  title: Text(
                    notif['pesan'] ?? '',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              // Delete each notification
              for (var notif in notifikasi) {
                if (notif != null &&
                    notif is Map &&
                    notif['id_notifikasi'] != null) {
                  await _deleteNotifikasi(notif['id_notifikasi'].toString());
                }
              }

              // Clear notifications from SharedPreferences
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('notifikasi');

              Navigator.of(ctx).pop(); // Close dialog
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Tutup',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  // Menampilkan dialog error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Terjadi Kesalahan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Halaman-halaman yang akan ditampilkan
  List<Widget> _pages() {
    return [
      _buildHomePage(),
      BukuPage(),
      ListPeminjamanPage(),
    ];
  }

  // Membuat halaman utama
  Widget _buildHomePage() {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Card(
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.home, color: Colors.blue.shade700, size: 80),
                const SizedBox(height: 20),
                Text(
                  'Selamat Datang, $_username',
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Mengatur tampilan halaman navigasi
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: AppBar(
                title: const Text(
                  'E-Libs',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade700, Colors.blue.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ),
            )
          : null,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Buku',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List Peminjaman',
          ),
        ],
        selectedItemColor: Colors.blue.shade900,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 12.0,
      ),
    );
  }
}
