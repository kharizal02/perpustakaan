import 'package:flutter/material.dart';
import 'package:e_libs/admin/mahasiswa/mahasiswa.dart';
import 'package:e_libs/admin/perpanjangan.dart';
import 'package:e_libs/admin/riwayat_pinjam.dart';
import 'package:e_libs/admin/tambahmahasiwa.dart';
import 'package:e_libs/admin/tambahbuku.dart';
import 'package:e_libs/admin/buku.dart';
import 'package:e_libs/admin/list_peminjaman.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomepage extends StatefulWidget {
  @override
  _AdminHomepageState createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  int _selectedIndex = 0;
  String? _adminEmail; // Variable untuk menyimpan email admin

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
  void initState() {
    super.initState();
    _loadAdminEmail();
  }

  // Fungsi untuk memuat email admin dari SharedPreferences
  Future<void> _loadAdminEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _adminEmail = prefs.getString('email');
    });
  }

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
            UserAccountsDrawerHeader(
              accountName:
                  const Text('Admin', style: TextStyle(color: Colors.white)),
              accountEmail: Text(
                _adminEmail ?? 'Email tidak tersedia',
                style: const TextStyle(color: Colors.white),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.blueAccent),
              ),
              decoration: const BoxDecoration(
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
