import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:perpustakaan/util/config/config.dart';

class TambahBukuPage extends StatefulWidget {
  @override
  _TambahBukuPageState createState() => _TambahBukuPageState();
}

class _TambahBukuPageState extends State<TambahBukuPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _penulisController = TextEditingController();
  final TextEditingController _tahunController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _halamanController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  String _status = 'tersedia';

  // List of Program Studi options
  List<String> _prodiOptions = [
    'D4 Teknik Informatika',
    'D3 Teknik Informatika',
    'D4 Teknik Komputer',
    'Sains Data Terapan',
    'D4 Teknik Mekatronika',
    'D4 Sistem Pembangkit Energi',
    'D4 Teknik Elektronika',
    'D3 Teknik Elektronika',
    'D4 Teknik Elektro Industri',
    'D3 Teknik Elektro Industri',
    'D4 Teknik Telekomunikasi',
    'D3 Teknik Telekomunikasi',
    'D4 Teknik Rekayasa Internet',
    'D4 Teknik Rekayasa Multimedia',
    'D3 Multimedia Kreatif',
    'D4 Teknologi Game',
  ];

  String? _selectedProdi; // For selected program studi

  Future<void> _tambahBuku() async {
    if (_formKey.currentState!.validate()) {
      try {
        var uri =
            Uri.http(AppConfig.API_HOST, '/perpustakaan/buku/tambah_buku.php');

        final response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'judul_buku': _judulController.text,
            'penulis': _penulisController.text,
            'prodi': _selectedProdi,
            'tahun_terbit': int.parse(_tahunController.text),
            'deskripsi': _deskripsiController.text,
            'jumlah_halaman': int.parse(_halamanController.text),
            'tag': _tagController.text,
            'status': _status,
          }),
        );

        final responseData = json.decode(response.body);

        if (response.statusCode == 200 && responseData['success']) {
          // Show success dialog
          _showSuccessDialog(responseData['message']);
          _formKey.currentState!.reset(); // Reset form
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'])),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $error')),
        );
      }
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Berhasil'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Buku
              _buildInputField(
                controller: _judulController,
                label: 'Judul Buku',
                hintText: 'Masukkan judul buku',
                validator: (value) =>
                    value!.isEmpty ? 'Judul harus diisi' : null,
              ),
              SizedBox(height: 16),
              // Penulis
              _buildInputField(
                controller: _penulisController,
                label: 'Penulis',
                hintText: 'Masukkan Penulis',
              ),
              SizedBox(height: 16),
              // Program Studi (Dropdown)
              _buildDropdownField(
                label: 'Program Studi',
                value: _selectedProdi,
                items: _prodiOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedProdi = value;
                  });
                },
              ),
              SizedBox(height: 16),
              // Tahun Terbit
              _buildInputField(
                controller: _tahunController,
                label: 'Tahun Terbit',
                hintText: 'Masukkan Tahun Terbit',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              // Deskripsi
              _buildInputField(
                controller: _deskripsiController,
                label: 'Deskripsi',
                hintText: 'Masukkan Deskripsi',
                maxLines: 3,
              ),
              SizedBox(height: 16),
              // Jumlah Halaman
              _buildInputField(
                controller: _halamanController,
                label: 'Jumlah Halaman',
                hintText: 'Masukkan Jumlah Halaman',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              // Tag
              _buildInputField(
                controller: _tagController,
                label: 'Tag',
                hintText: 'Masukkan Tag',
              ),
              SizedBox(height: 16),
              // Status Dropdown
              _buildDropdownField(
                label: 'Status',
                value: _status,
                items: ['tersedia', 'dipinjam'],
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
              ),
              SizedBox(height: 24),
              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _tambahBuku,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Tambah Buku',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((status) =>
                DropdownMenuItem(value: status, child: Text(status)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }
}
