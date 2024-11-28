import 'package:flutter/material.dart';
import 'package:perpustakaan/admin/mahasiswa/mahasiswa.dart';
import 'package:perpustakaan/admin/perpanjangan.dart';
import 'package:perpustakaan/admin/riwayat_pinjam.dart';
import 'package:perpustakaan/admin/tambahmahasiwa.dart';
import 'package:perpustakaan/admin/tambahbuku.dart';
import 'package:perpustakaan/admin/buku.dart';
import 'package:perpustakaan/admin/list_peminjaman.dart';

class AdminHomepage extends StatefulWidget {
  @override
  _AdminHomepageState createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    BukuPageAdmin(), // Halaman Buku
    TambahBukuPage(), // Halaman Tambah Buku
    ListPeminjamanPage(), // Halaman List Peminjaman
    PerpanjanganPage(), // Halaman Perpanjangan
    RiwayatBookingPage(), // Halaman Riwayat Pinjam
    MahasiswaPage(), // Halaman Mahasiswa
    TambahMahasiswaPage(), // Halaman Tambah Mahasiswa
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'E-Libs',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            shadows: [
              BoxShadow(
                color: Colors.black54,
                offset: Offset(2, 2),
                blurRadius: 4,
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
            borderRadius: const BorderRadius.only(
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
            const UserAccountsDrawerHeader(
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
              leading: const Icon(Icons.book, color: Colors.white),
              title: const Text('Buku', style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box, color: Colors.white),
              title: const Text('Tambah Buku',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list, color: Colors.white),
              title: const Text('List Peminjaman',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.update, color: Colors.white),
              title: const Text('Perpanjangan',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.white),
              title: const Text('Riwayat Pinjam',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 4;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.white),
              title: const Text('Mahasiswa',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 5;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add, color: Colors.white),
              title: const Text('Tambah Mahasiswa',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 6;
                });
                Navigator.pop(context);
              },
            ),
            // Menu Log Out
            const Divider(),
            MouseRegion(
              onEnter: (_) => setState(() {}),
              onExit: (_) => setState(() {}),
              child: ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.white),
                title: const Text(
                  'Keluar',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
