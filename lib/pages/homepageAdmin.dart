import 'package:flutter/material.dart';

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
    TambahMahasiswaPage(), // Halaman Tambah Mahasiswa
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
                Navigator.pop(context); // Menutup drawer setelah menu dipilih
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
                Navigator.pop(context); // Menutup drawer setelah menu dipilih
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
                Navigator.pop(context); // Menutup drawer setelah menu dipilih
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.white),
              title: const Text('Mahasiswa',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context); // Menutup drawer setelah menu dipilih
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
                Navigator.pop(context); // Menutup drawer setelah menu dipilih
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add, color: Colors.white),
              title: const Text('Tambah Mahasiswa',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 5;
                });
                Navigator.pop(context); // Menutup drawer setelah menu dipilih
              },
            ),
            ListTile(
              leading: const Icon(Icons.report_problem, color: Colors.white),
              title: const Text('Data Telat',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 6;
                });
                Navigator.pop(context); // Menutup drawer setelah menu dipilih
              },
            ),
            ListTile(
              leading: const Icon(Icons.update, color: Colors.white),
              title: const Text('Perpanjangan',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  _selectedIndex = 7;
                });
                Navigator.pop(context); // Menutup drawer setelah menu dipilih
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
class BukuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Halaman Buku"),
    );
  }
}

class TambahBukuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Halaman Tambah Buku"),
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

class TambahMahasiswaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Halaman Tambah Mahasiswa"),
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
