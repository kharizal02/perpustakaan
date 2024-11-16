
import 'package:flutter/material.dart';
import 'package:perpustakaan/admin/buku.dart';
import 'package:perpustakaan/model/buku.dart';

import '../admin/tambahbuku.dart';
import '../admin/tambahmahasiwa.dart';

class AdminHomepage extends StatefulWidget {
  @override
  _AdminHomepageState createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  int _selectedIndex = 0; // Menyimpan index menu yang dipilih

  // Daftar widget untuk setiap menu
  final List<Widget> _pages = [
    BukuPage(), // Halaman Buku
    TambahBukuPage(), // Halaman Tambah Buku
    ListPeminjamanPage(), // Halaman List Peminjaman
    MahasiswaPage(), // Halaman Mahasiswa
    RiwayatPinjamPage(), // Halaman Riwayat Pinjam
    AddMahasiswaForm(), // Halaman Tambah Mahasiswa
    DataTelatPage(), // Halaman Data Telat
    PerpanjanganPage(), // Halaman Perpanjangan
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'E-Libs',
          style: TextStyle(
            color: Colors.white, // Warna teks putih
            fontSize: 24, // Ukuran font
            fontWeight: FontWeight.bold, // Tebal
            shadows: [
              BoxShadow(
                color: Colors.black54, // Warna bayangan
                offset: Offset(2, 2), // Posisi bayangan
                blurRadius: 4, // Ukuran bayangan
              ),
            ],
          ),
        ),
        backgroundColor: Colors.blueAccent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.blueAccent,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Header drawer dengan gambar atau nama
            UserAccountsDrawerHeader(
              accountName: Text('Admin', style: TextStyle(color: Colors.white)),
              accountEmail: Text('admin@example.com',
                  style: TextStyle(color: Colors.white)),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.blueAccent),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Menu items dalam Drawer
            ListTile(
              leading: Icon(Icons.book, color: Colors.white),
              title: Text('Buku', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>BukuPageAdmin(),),);
                       
              },
            ),
            ListTile(
              leading: Icon(Icons.add_box, color: Colors.white),
              title: Text('Tambah Buku', style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context); // Menutup drawer setelah menu dipilih
              },
            ),
            ListTile(
              leading: Icon(Icons.list, color: Colors.white),
              title: Text('List Peminjaman',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context); // Menutup drawer setelah menu dipilih
              },
            ),
            ListTile(
              leading: Icon(Icons.people, color: Colors.white),
              title: Text('Mahasiswa', style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context); // Menutup drawer setelah menu dipilih
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.white),
              title:
                  Text('Riwayat Pinjam', style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 4;
                });
                Navigator.pop(context); // Menutup drawer setelah menu dipilih
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add, color: Colors.white),
              title: Text('Tambah Mahasiswa',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 5;
                });
                Navigator.pop(context); // Menutup drawer setelah menu dipilih
              },
            ),
            ListTile(
              leading: Icon(Icons.report_problem, color: Colors.white),
              title: Text('Data Telat', style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 6;
                });
                Navigator.pop(context); // Menutup drawer setelah menu dipilih
              },
            ),
            ListTile(
              leading: Icon(Icons.update, color: Colors.white),
              title:
                  Text('Perpanjangan', style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 7;
                });
                Navigator.pop(context); // Menutup drawer setelah menu dipilih
              },
            ),
            // Menu Log Out
            Divider(),
            MouseRegion(
              onEnter: (_) => setState(() {}),
              onExit: (_) => setState(() {}),
              child: ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.white),
                title: Text(
                  'Keluar',
                  style: TextStyle(
                      color: Colors.red), // Warna merah untuk "Keluar"
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, '/login'); // Arahkan ke halaman login
                },
              ),
            ),
          ],
        ),
      ),
      body: _pages[
          _selectedIndex], // Menampilkan halaman berdasarkan index yang dipilih
    );
  }
}

// Contoh widget halaman (Anda bisa menyesuaikan halaman-halaman ini)




class ListPeminjamanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Halaman List Peminjaman"),
    );
  }
}

class MahasiswaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Halaman Mahasiswa"),
    );
  }
}

class RiwayatPinjamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Halaman Riwayat Pinjam"),
    );
  }
}



class DataTelatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Halaman Data Telat"),
    );
  }
}

class PerpanjanganPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Halaman Perpanjangan"),
    );
  }
}
