import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:perpustakaan/util/config/config.dart';

class MahasiswaPage extends StatefulWidget {
  final Map<String, dynamic>? mahasiswaDetail;

  MahasiswaPage(
      {this.mahasiswaDetail}); // Konstruktor dengan parameter opsional

  @override
  _MahasiswaPageState createState() => _MahasiswaPageState();
}

class _MahasiswaPageState extends State<MahasiswaPage> {
  List<Map<String, dynamic>> _mahasiswaList = [];
  List<Map<String, dynamic>> _filteredMahasiswaList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMahasiswaData(); // Ambil data mahasiswa dari API saat halaman dimuat
  }

  // Fungsi untuk mengambil data mahasiswa dari API
  Future<void> _fetchMahasiswaData() async {
    var uri = Uri.http(
        AppConfig.API_HOST, '/perpustakaan/mahasiswa/get_mahasiswa.php');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          // Ambil seluruh data mahasiswa
          _mahasiswaList = List<Map<String, dynamic>>.from(data['data']);
          _filteredMahasiswaList =
              _mahasiswaList; // Awalnya tampilkan semua mahasiswa
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(data['message'] ?? 'Gagal mengambil data mahasiswa.')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil data dari server.')));
    }
  }

  // Fungsi untuk memfilter daftar mahasiswa berdasarkan pencarian
  void _filterMahasiswaList(String query) {
    setState(() {
      _filteredMahasiswaList = _mahasiswaList
          .where((mahasiswa) =>
              mahasiswa['nama'].toLowerCase().contains(query.toLowerCase()) ||
              mahasiswa['nrp'].toString().contains(query))
          .toList();
    });
  }

  // Widget untuk menampilkan detail mahasiswa
  Widget _buildMahasiswaDetail(Map<String, dynamic> mahasiswa) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF42A5F5),
        title: Text('Detail Mahasiswa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    mahasiswa['nama'],
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800]),
                  ),
                ),
                SizedBox(height: 20),
                _buildDetailRow('NRP', mahasiswa['nrp'].toString()),
                _buildDetailRow('Program Studi', mahasiswa['prodi']),
                _buildDetailRow('Semester', mahasiswa['semester'].toString()),
                _buildDetailRow('Status', mahasiswa['status']),
                _buildDetailRow('Tanggal Lahir', mahasiswa['tgl_lahir']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget untuk membuat baris detail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.grey[800])),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.blue[700])),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Jika detail mahasiswa sudah diberikan, tampilkan detail
    if (widget.mahasiswaDetail != null) {
      return _buildMahasiswaDetail(widget.mahasiswaDetail!);
    }

    // Jika tidak, tampilkan daftar mahasiswa
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            onChanged: (query) => _filterMahasiswaList(query),
            decoration: InputDecoration(
              hintText: 'Cari Nama atau NRP',
              hintStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.7),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _filteredMahasiswaList.length,
              itemBuilder: (context, index) {
                final mahasiswa = _filteredMahasiswaList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MahasiswaPage(mahasiswaDetail: mahasiswa),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mahasiswa['nama'],
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800]),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'NRP: ${mahasiswa['nrp']}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600]),
                          ),
                          Text(
                            'Prodi: ${mahasiswa['prodi']}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
