import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:perpustakaan/util/config/config.dart';

class TambahMahasiswaPage extends StatefulWidget {
  @override
  _TambahMahasiswaPageState createState() => _TambahMahasiswaPageState();
}

class _TambahMahasiswaPageState extends State<TambahMahasiswaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nrpController = TextEditingController();
  final TextEditingController _semesterController = TextEditingController();
  final TextEditingController _tglLahirController = TextEditingController();
  String _status = 'Aktif';

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

  String? _selectedProdi;

  Future<void> _tambahMahasiswa() async {
    if (_formKey.currentState!.validate()) {
      // Periksa apakah Program Studi dipilih
      if (_selectedProdi == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Program Studi harus dipilih!')),
        );
        return;
      }

      try {
        var uri = Uri.http(
            AppConfig.API_HOST, '/perpustakaan/mahasiswa/tambah_mahasiswa.php');

        final response = await http.post(
          uri,
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {
            'nama': _namaController.text,
            'nrp': _nrpController.text,
            'status': _status,
            'prodi': _selectedProdi ?? '',
            'semester': _semesterController.text.isEmpty
                ? '1'
                : _semesterController.text,
            'tgl_lahir': _tglLahirController.text,
          },
        );

        final responseData = json.decode(response.body);

        if (response.statusCode == 200 && responseData['status'] == 'success') {
          // Jika berhasil
          _showDialog(
            title: 'Sukses',
            content: responseData['message'],
            isSuccess: true,
          );
          _formKey.currentState!.reset(); // Reset form
          setState(() {
            _selectedProdi = null; // Reset dropdown
          });
        } else {
          // Jika gagal
          _showDialog(
            title: 'Gagal',
            content: responseData['message'] ?? 'Gagal menambahkan mahasiswa.',
            isSuccess: false,
          );
        }
      } catch (error) {
        // Jika terjadi kesalahan jaringan atau lainnya
        _showDialog(
          title: 'Kesalahan',
          content: 'Terjadi kesalahan: $error',
          isSuccess: false,
        );
      }
    }
  }

  void _showDialog(
      {required String title,
      required String content,
      required bool isSuccess}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title,
              style: TextStyle(color: isSuccess ? Colors.green : Colors.red)),
          content: Text(content),
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
              // Nama
              _buildInputField(
                controller: _namaController,
                label: 'Nama',
                hintText: 'Masukkan Nama Mahasiswa',
                validator: (value) =>
                    value!.isEmpty ? 'Nama harus diisi' : null,
              ),
              SizedBox(height: 16),
              // NRP
              _buildInputField(
                controller: _nrpController,
                label: 'NRP',
                hintText: 'Masukkan NRP',
                validator: (value) => value!.isEmpty ? 'NRP harus diisi' : null,
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
              // Semester
              _buildInputField(
                controller: _semesterController,
                label: 'Semester',
                hintText: 'Masukkan Semester',
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Semester harus diisi' : null,
              ),
              SizedBox(height: 16),
              // Tanggal Lahir
              _buildInputField(
                controller: _tglLahirController,
                label: 'Tanggal Lahir',
                hintText: 'Masukkan Tanggal Lahir (YYYY-MM-DD)',
                keyboardType: TextInputType.datetime,
                validator: (value) =>
                    value!.isEmpty ? 'Tanggal lahir harus diisi' : null,
              ),
              SizedBox(height: 16),
              // Status Dropdown
              _buildDropdownField(
                label: 'Status',
                value: _status,
                items: ['Aktif', 'Tidak Aktif'],
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
                  onPressed: _tambahMahasiswa,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Tambah Mahasiswa',
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
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
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
