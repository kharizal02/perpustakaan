import 'package:flutter/material.dart';

class PerpanjanganPage extends StatefulWidget {
  final String judulBuku;
  final String peminjam;
  final String tanggalPengembalian; // Menambahkan parameter tanggalPengembalian

  PerpanjanganPage({
    Key? key,
    required this.judulBuku,
    required this.peminjam,
    required this.tanggalPengembalian, // Menerima tanggal pengembalian
  }) : super(key: key);

  @override
  _PerpanjanganPageState createState() => _PerpanjanganPageState();
}

class _PerpanjanganPageState extends State<PerpanjanganPage> {
  DateTime? _selectedDate;

  // Function to pick the date using the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Set current date as initial date
      firstDate: DateTime.now(), // Set the first selectable date
      lastDate: DateTime(2101), // Set the last selectable date
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perpanjangan Peminjaman'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        // Tambahkan SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menampilkan Judul Buku dan Peminjam
              Text(
                'Judul Buku: ${widget.judulBuku}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Peminjam: ${widget.peminjam}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              // Menampilkan Tanggal Pengembalian
              const Text(
                'Tanggal Pengembalian Asli:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                widget.tanggalPengembalian, // Tanggal pengembalian asli
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
              const SizedBox(height: 16),

              // Form untuk memilih tanggal perpanjangan
              const Text(
                'Tenggat Waktu Perpanjangan:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(
                        _selectedDate != null
                            ? '${_selectedDate!.toLocal()}'.split(' ')[0]
                            : 'Pilih tanggal',
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Alasan Perpanjangan
              const Text(
                'Alasan Perpanjangan:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              const TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan alasan perpanjangan...',
                ),
              ),
              const SizedBox(height: 16),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Pilih tanggal perpanjangan')),
                      );
                      return;
                    }

                    // Handle perpanjangan
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Perpanjangan berhasil diajukan')),
                    );
                  },
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
