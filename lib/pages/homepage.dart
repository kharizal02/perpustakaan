import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:perpustakaan/model/buku.dart'; // Import model BukuPage
import 'package:perpustakaan/model/list_peminjaman.dart'; // Import model ListPeminjamanPage

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

  HomePage(
      {this.initialIndex =
          0}); // Menambahkan parameter initialIndex dengan default 0

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String _username = ''; // Variabel untuk menyimpan nama pengguna

  // Fungsi untuk mengambil data pengguna dari SharedPreferences
  Future<void> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('nama') ??
          'User'; // Ambil nama dari SharedPreferences
    });
  }

  // Membuat halaman dinamis
  List<Widget> _pages() {
    return [
      _buildHomePage(), // Home tab with custom AppBar
      BukuPage(), // Buku page with default AppBar (no custom changes)
      ListPeminjamanPage(), // List Peminjaman page
    ];
  }

  // Function to create the Home page
  Widget _buildHomePage() {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Card(
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.home, color: Colors.blue.shade700, size: 80),
                SizedBox(height: 20),
                Text(
                  'Selamat Datang, $_username', // Display the username here
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center, // Center-align the text
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildPage(String title, Color color) {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Card(
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.library_books,
                    color: Colors.blue.shade700, size: 60),
                SizedBox(height: 20),
                Text(
                  title,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserData(); // Memanggil fungsi untuk mengambil data pengguna saat halaman pertama kali dibuka
    _currentIndex =
        widget.initialIndex; // Mengatur indeks berdasarkan parameter
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? PreferredSize(
              preferredSize: Size.fromHeight(80), // AppBar height for Home page
              child: AppBar(
                title: Text(
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
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ),
            )
          : null, // No AppBar for other pages

      body: IndexedStack(
        index: _currentIndex,
        children: _pages(), // Memanggil fungsi untuk mendapatkan halaman
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: [
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
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
