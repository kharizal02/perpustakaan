import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:perpustakaan/util/config/config.dart';
import 'package:perpustakaan/pages/homepage.dart';

class BookingPage extends StatefulWidget {
  final String nrp;
  final String nama;
  final String judulBuku;

  BookingPage({required this.nrp, required this.nama, required this.judulBuku});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  bool _isChecked = false; // Persetujuan tata tertib

  // Fungsi untuk melakukan pemesanan buku
  Future<void> _bookBuku() async {
    final bookingDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final returnDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 14)));

    try {
      var uri = Uri.http(AppConfig.API_HOST, '/perpustakaan/buku/booking.php');
      var response = await http.post(
        uri,
        body: {
          'nrp': widget.nrp,
          'nama': widget.nama,
          'judul_buku': widget.judulBuku,
          'tanggal_booking': bookingDate,
          'tanggal_pengembalian': returnDate,
        },
      );
      var data = json.decode(response.body);

      if (data['status'] == 'success') {
        // Menampilkan dialog saat booking berhasil
        _showDialog(data['message'], true);
      } else {
        // Menampilkan dialog jika gagal
        _showDialog(data['message'], false);
      }
    } catch (e) {
      // Menampilkan pesan error jika terjadi masalah dengan koneksi atau lainnya
      _showSnackbar("Terjadi kesalahan: $e");
    }
  }

  // Fungsi untuk menampilkan SnackBar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Fungsi untuk menampilkan Dialog
  void _showDialog(String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pemberitahuan"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                if (isSuccess) {
                  // Jika booking berhasil, arahkan ke HomePage dan langsung ke tab List Peminjaman
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                          initialIndex: 2), // Tab List Peminjaman (index 2)
                    ),
                  );
                }
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final returnDate =
        DateFormat('dd-MM-yyyy').format(DateTime.now().add(Duration(days: 14)));

    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Buku"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Informasi Pengguna
                Text(
                  'Informasi Pengguna',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(thickness: 1),
                SizedBox(height: 10),
                Text('NRP: ${widget.nrp}', style: TextStyle(fontSize: 18)),
                Text('Nama: ${widget.nama}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),

                // Informasi Buku
                Text(
                  'Informasi Buku',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(thickness: 1),
                SizedBox(height: 10),
                Text('Judul Buku: ${widget.judulBuku}'),
                SizedBox(height: 20),

                // Tanggal Booking & Pengembalian
                Text(
                  'Tanggal Booking & Pengembalian',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(thickness: 1),
                SizedBox(height: 10),
                Text('Tanggal Booking: $bookingDate'),
                Text('Tanggal Pengembalian: $returnDate'),
                SizedBox(height: 20),

                // Persetujuan Tata Tertib
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Setuju dengan Tata Tertib Peminjaman?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                // Tombol Booking
                Center(
                  child: ElevatedButton(
                    onPressed: _isChecked ? _bookBuku : null,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      'Booking Sekarang',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
