import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:e_libs/util/config/config.dart'; // Pastikan AppConfig sudah diatur

class PerpanjanganPage extends StatefulWidget {
  final String idBooking;
  final String judulBuku;
  final String peminjam;
  final String tanggalPengembalian;

  PerpanjanganPage({
    Key? key,
    required this.idBooking,
    required this.judulBuku,
    required this.peminjam,
    required this.tanggalPengembalian,
  }) : super(key: key);

  @override
  _PerpanjanganPageState createState() => _PerpanjanganPageState();
}

class _PerpanjanganPageState extends State<PerpanjanganPage> {
  DateTime? _selectedDate;
  TextEditingController _alasanController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime tanggalPengembalianAsli =
        DateTime.parse(widget.tanggalPengembalian);

    DateTime tanggalBatasPerpanjangan =
        tanggalPengembalianAsli.add(Duration(days: 14));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: tanggalBatasPerpanjangan,
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitPerpanjangan() async {
    if (_selectedDate == null || _alasanController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Validasi Gagal"),
            content: const Text("Harap pilih tanggal dan masukkan alasan."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    var uri =
        Uri.http(AppConfig.API_HOST, '/perpustakaan/buku/perpanjangan.php');
    try {
      var response = await http.post(uri, body: {
        'id_booking': widget.idBooking,
        'tanggal_perpanjangan': _selectedDate!.toIso8601String().split('T')[0],
        'alasan': _alasanController.text,
      });

      var data = json.decode(response.body);

      if (data['status'] == 'success') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Perpanjangan Berhasil"),
              content: Text(
                  "Perpanjangan untuk buku ${widget.judulBuku} berhasil diajukan."),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Perpanjangan Gagal"),
              content: Text(data['message'] ??
                  'Terjadi kesalahan pada server, mohon coba lagi.'),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text('Error: ${e.toString()}'),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perpanjangan Peminjaman'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ID Booking: ${widget.idBooking}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Judul Buku: ${widget.judulBuku}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Peminjam: ${widget.peminjam}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tanggal Pengembalian Asli:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                widget.tanggalPengembalian,
                style: const TextStyle(fontSize: 16, color: Colors.blue),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tenggat Waktu Perpanjangan:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.blue),
                      const SizedBox(width: 10),
                      Text(
                        _selectedDate != null
                            ? '${_selectedDate!.toLocal()}'.split(' ')[0]
                            : 'Pilih tanggal',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Alasan Perpanjangan:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _alasanController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan alasan perpanjangan...',
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _submitPerpanjangan,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Ajukan Perpanjangan',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
