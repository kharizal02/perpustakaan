import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:e_libs/util/config/config.dart';
import 'package:e_libs/pages/homepage.dart';

class BookingPage extends StatefulWidget {
  final String nrp;
  final String nama;
  final String idBuku; // ID buku
  final String judulBuku; // Judul buku

  const BookingPage({
    super.key,
    required this.nrp,
    required this.nama,
    required this.idBuku,
    required this.judulBuku,
  });

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  bool _isChecked = false; // Persetujuan tata tertib
  DateTime? _selectedReturnDate; // Tanggal pengembalian yang dipilih pengguna
  final DateTime _maxReturnDate = DateTime.now()
      .add(const Duration(days: 14)); // Batas maksimal tanggal pengembalian

  // Fungsi untuk memilih tanggal pengembalian
  Future<void> _selectReturnDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: _maxReturnDate,
    );

    if (pickedDate != null && pickedDate != _selectedReturnDate) {
      setState(() {
        _selectedReturnDate = pickedDate;
      });
    }
  }

  // Fungsi untuk mengecek peminjaman aktif
  Future<bool> _checkPeminjamanAktif() async {
    try {
      var uri = Uri.http(AppConfig.API_HOST,
          '/perpustakaan/booking/check_booking.php', {'nrp': widget.nrp});
      var response = await http.get(uri);

      var data = json.decode(response.body);
      if (data['status'] == 'error') {
        _showDialog(data['message'], false);
        return false;
      }
      return true; // Mahasiswa dapat melakukan peminjaman
    } catch (e) {
      _showSnackbar("Terjadi kesalahan: $e");
      return false;
    }
  }

  // Fungsi untuk melakukan booking buku
  Future<void> _bookBuku() async {
    // Periksa peminjaman aktif terlebih dahulu
    bool canBook = await _checkPeminjamanAktif();
    if (!canBook) {
      return; // Jika sudah ada 2 peminjaman aktif, tidak lanjutkan
    }

    final bookingDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final returnDate = DateFormat('yyyy-MM-dd').format(_selectedReturnDate!);

    try {
      var uri =
          Uri.http(AppConfig.API_HOST, '/perpustakaan/booking/booking.php');
      var response = await http.post(
        uri,
        body: {
          'nrp': widget.nrp,
          'nama': widget.nama,
          'id_buku': widget.idBuku,
          'judul_buku': widget.judulBuku, // Tambahkan judul buku ke server
          'tanggal_booking': bookingDate,
          'tanggal_pengembalian': returnDate,
        },
      );

      var data = json.decode(response.body);

      if (data['status'] == 'success') {
        _showDialog(data['message'], true);
      } else {
        _showDialog(data['message'], false);
      }
    } catch (e) {
      _showSnackbar("Terjadi kesalahan: $e");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showDialog(String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pemberitahuan"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (isSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(initialIndex: 2),
                    ),
                  );
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Buku"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informasi Pengguna',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Divider(thickness: 1),
                const SizedBox(height: 10),
                Text('NRP: ${widget.nrp}',
                    style: const TextStyle(fontSize: 18)),
                Text('Nama: ${widget.nama}',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                const Text(
                  'Informasi Buku',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Divider(thickness: 1),
                const SizedBox(height: 10),
                Text('ID Buku: ${widget.idBuku}',
                    style: const TextStyle(fontSize: 18)),
                Text('Judul Buku: ${widget.judulBuku}',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                const Text(
                  'Tanggal Booking & Pengembalian',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Divider(thickness: 1),
                const SizedBox(height: 10),
                Text('Tanggal Booking: $bookingDate'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _selectReturnDate(context),
                      child: const Text("Pilih Tanggal Pengembalian"),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _selectedReturnDate != null
                          ? DateFormat('dd-MM-yyyy')
                              .format(_selectedReturnDate!)
                          : 'Belum dipilih',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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
                    const Expanded(
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
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _isChecked && _selectedReturnDate != null
                        ? _bookBuku
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
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
