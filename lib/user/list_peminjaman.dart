import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:perpustakaan/util/config/config.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:perpustakaan/user/perpanjangan.dart';

class ListPeminjamanPage extends StatefulWidget {
  @override
  _ListPeminjamanPageState createState() => _ListPeminjamanPageState();
}

class _ListPeminjamanPageState extends State<ListPeminjamanPage> {
  String? nrp;
  List<dynamic> peminjamanData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getNrp(); // Ambil nrp dari SharedPreferences saat halaman dimuat
  }

  // Mengambil nrp dari SharedPreferences
  Future<void> _getNrp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nrp = prefs.getString('nrp');
    });

    if (nrp != null) {
      _fetchPeminjaman(nrp!); // Ambil data peminjaman berdasarkan nrp
    } else {
      _showErrorDialog("NRP is null! Make sure you are logged in.");
    }
  }

  // Fungsi untuk mengambil data peminjaman berdasarkan nrp
  Future<void> _fetchPeminjaman(String nrp) async {
    try {
      var uri = Uri.http(AppConfig.API_HOST,
          '/perpustakaan/buku/get_booking.php', {'nrp': nrp});
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['status'] == 'success') {
          setState(() {
            peminjamanData = data['data'] ?? [];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load data.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Error: ${e.toString()}');
    }
  }

  // Menampilkan dialog error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Menampilkan dialog sukses
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sukses'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Peminjaman'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : peminjamanData.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada peminjaman untuk ditampilkan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  itemCount: peminjamanData.length,
                  itemBuilder: (context, index) {
                    var peminjaman = peminjamanData[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Icon(Icons.book, color: Colors.blueAccent),
                        title: Text(
                          peminjaman['judul_buku'] ?? 'No Title',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text(
                              'Tanggal Peminjaman: ${peminjaman['tanggal_booking']}',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Tenggat Pengembalian: ${peminjaman['tanggal_pengembalian']}',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.alarm_add, color: Colors.orange),
                              onPressed: () {
                                // Arahkan ke halaman PerpanjanganPage
                                if (peminjaman['judul_buku'] != null &&
                                    peminjaman['nama'] != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PerpanjanganPage(
                                        judulBuku: peminjaman['judul_buku'] ??
                                            'No Title',
                                        peminjam:
                                            peminjaman['nama'] ?? 'Unknown',
                                        tanggalPengembalian: peminjaman[
                                                'tanggal_pengembalian'] ??
                                            'No Date', // Pastikan tanggal pengembalian dikirimkan
                                      ),
                                    ),
                                  );
                                } else {
                                  _showErrorDialog(
                                      'Data peminjaman tidak lengkap.');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
