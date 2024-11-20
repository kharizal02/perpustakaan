import 'package:flutter/material.dart';
import 'package:perpustakaan/admin/buku.dart';
import 'package:perpustakaan/admin/tambahmahasiwa.dart';
import 'package:perpustakaan/admin/tambahbuku.dart';

class AdminHomepage extends StatefulWidget {
  @override
  _AdminHomepageState createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  int _selectedIndex = 0; // Menyimpan index menu yang dipilih

  // Daftar widget untuk setiap menu
  final List<Widget> _pages = [
    BukuPageAdmin(), // Halaman Buku
    TambahBukuPage(), // Halaman Tambah Buku
    ListPeminjamanPage(), // Halaman List Peminjaman
    MahasiswaPage(), // Halaman Mahasiswa
    RiwayatPinjamPage(), // Halaman Riwayat Pinjam
    AddMahasiswaForm(), // Halaman Tambah Mahasiswa
    DataTelatPage(), // Halaman Data Telat
    PerpanjanganPage(), // Halaman Perpanjangan
  ];

  void _onMenuSelected(int index) {
    setState(() {
      _selectedIndex = index; // Ganti index saat menu dipilih
    });
    Navigator.pop(context); // Tutup drawer setelah memilih menu
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
            ListTile(
              leading: const Icon(Icons.book, color: Colors.white),
              title: const Text('Buku', style: TextStyle(color: Colors.white)),
              onTap: () => _onMenuSelected(0),
            ),
            ListTile(
              leading: const Icon(Icons.add_box, color: Colors.white),
              title: const Text('Tambah Buku',
                  style: TextStyle(color: Colors.white)),
              onTap: () => _onMenuSelected(1),
            ),
            ListTile(
              leading: const Icon(Icons.list, color: Colors.white),
              title: const Text('List Peminjaman',
                  style: TextStyle(color: Colors.white)),
              onTap: () => _onMenuSelected(2),
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.white),
              title: const Text('Mahasiswa',
                  style: TextStyle(color: Colors.white)),
              onTap: () => _onMenuSelected(3),
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.white),
              title: const Text('Riwayat Pinjam',
                  style: TextStyle(color: Colors.white)),
              onTap: () => _onMenuSelected(4),
            ),
            ListTile(
              leading: const Icon(Icons.person_add, color: Colors.white),
              title: const Text('Tambah Mahasiswa',
                  style: TextStyle(color: Colors.white)),
              onTap: () => _onMenuSelected(5),
            ),
            ListTile(
              leading: const Icon(Icons.report_problem, color: Colors.white),
              title: const Text('Data Telat',
                  style: TextStyle(color: Colors.white)),
              onTap: () => _onMenuSelected(6),
            ),
            ListTile(
              leading: const Icon(Icons.update, color: Colors.white),
              title: const Text('Perpanjangan',
                  style: TextStyle(color: Colors.white)),
              onTap: () => _onMenuSelected(7),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.white),
              title: const Text(
                'Keluar',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}

class ListPeminjamanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Halaman List Peminjaman"),
    );
  }
}

class MahasiswaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Halaman Mahasiswa"),
    );
  }
}

class RiwayatPinjamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Halaman Riwayat Pinjam"),
    );
  }
}

class DataTelatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Halaman Data Telat"),
    );
  }
}

class PerpanjanganPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Halaman Perpanjangan"),
    );
  }
}
