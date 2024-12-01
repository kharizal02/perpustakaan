import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:e_libs/util/config/config.dart';

class MahasiswaPage extends StatefulWidget {
  final Map<String, dynamic>? mahasiswaDetail;

  MahasiswaPage({this.mahasiswaDetail}); // Constructor with optional parameter

  @override
  _MahasiswaPageState createState() => _MahasiswaPageState();
}

class _MahasiswaPageState extends State<MahasiswaPage> {
  List<Map<String, dynamic>> _mahasiswaList = [];
  List<Map<String, dynamic>> _filteredMahasiswaList = [];
  final TextEditingController _searchController = TextEditingController();

  // Controllers for editing student details
  TextEditingController _namaController = TextEditingController();
  TextEditingController _nrpController = TextEditingController();
  TextEditingController _prodiController = TextEditingController();
  TextEditingController _semesterController = TextEditingController();
  TextEditingController _tglLahirController = TextEditingController();

  // Variable for status (Aktif/Tidak Aktif)
  String _status = 'Aktif';

  @override
  void initState() {
    super.initState();
    if (widget.mahasiswaDetail != null) {
      // Initialize controllers with existing data if viewing a student's details
      _namaController.text = widget.mahasiswaDetail!['nama'];
      _nrpController.text = widget.mahasiswaDetail!['nrp'].toString();
      _prodiController.text = widget.mahasiswaDetail!['prodi'];
      _semesterController.text = widget.mahasiswaDetail!['semester'].toString();
      _status = widget.mahasiswaDetail!['status']; // Set the existing status
      _tglLahirController.text = widget.mahasiswaDetail!['tgl_lahir'];
    }
    _fetchMahasiswaData(); // Fetch student data from API when the page loads
  }

  // Function to fetch student data from the API
  Future<void> _fetchMahasiswaData() async {
    var uri = Uri.http(
        AppConfig.API_HOST, '/perpustakaan/mahasiswa/get_mahasiswa.php');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          _mahasiswaList = List<Map<String, dynamic>>.from(data['data']);
          _filteredMahasiswaList = _mahasiswaList;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data['message'] ?? 'Failed to fetch student data.')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch data from server.')));
    }
  }

  // Function to filter student list based on search
  void _filterMahasiswaList(String query) {
    setState(() {
      _filteredMahasiswaList = _mahasiswaList
          .where((mahasiswa) =>
              mahasiswa['nama'].toLowerCase().contains(query.toLowerCase()) ||
              mahasiswa['nrp'].toString().contains(query))
          .toList();
    });
  }

  Future<void> _updateMahasiswa() async {
    var uri = Uri.http(
        AppConfig.API_HOST, '/perpustakaan/mahasiswa/update_mahasiswa.php');
    final response = await http.post(uri, body: {
      'id_mahasiswa': widget.mahasiswaDetail!['id_mahasiswa'].toString(),
      'nama': _namaController.text,
      'nrp': _nrpController.text,
      'prodi': _prodiController.text,
      'semester': _semesterController.text,
      'status': _status, // Send the updated status
      'tgl_lahir': _tglLahirController.text,
    });

    final data = json.decode(response.body);
    if (data['status'] == 'success') {
      // Update local data for the detailed student view
      setState(() {
        widget.mahasiswaDetail!['nama'] = _namaController.text;
        widget.mahasiswaDetail!['nrp'] = _nrpController.text;
        widget.mahasiswaDetail!['prodi'] = _prodiController.text;
        widget.mahasiswaDetail!['semester'] = _semesterController.text;
        widget.mahasiswaDetail!['status'] = _status;
        widget.mahasiswaDetail!['tgl_lahir'] = _tglLahirController.text;
      });

      // Close the dialog and show success feedback
      Navigator.pop(context); // Close the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Berhasil'),
            content: Text('Data mahasiswa berhasil diperbarui.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the success dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Show failure feedback
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data mahasiswa.')));
    }
  }

  // Widget to display student details
  Widget _buildMahasiswaDetail(Map<String, dynamic> mahasiswa) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF42A5F5),
        title: Text('Student Details'),
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _showUpdateDialog,
                  child: Text('Update Student'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget to create each row in student details
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

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Update Status Mahasiswa'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama (readonly)
                    _buildReadOnlyTextField(_namaController, 'Nama'),

                    // NRP (readonly)
                    _buildReadOnlyTextField(_nrpController, 'NRP'),

                    // Program Studi (readonly)
                    _buildReadOnlyTextField(_prodiController, 'Program Studi'),

                    // Semester (readonly)
                    _buildReadOnlyTextField(_semesterController, 'Semester'),

                    // Tanggal Lahir (readonly)
                    _buildReadOnlyTextField(
                        _tglLahirController, 'Tanggal Lahir'),

                    // Pilihan Status (Aktif/Tidak Aktif)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Status',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800])),
                          Row(
                            children: [
                              // Aktif Status Button
                              _buildStatusButton(
                                  context: context,
                                  text: 'Aktif',
                                  isSelected: _status == 'Aktif',
                                  onPressed: () {
                                    setState(() {
                                      _status = 'Aktif';
                                    });
                                  }),
                              SizedBox(width: 10),
                              // Tidak Aktif Status Button
                              _buildStatusButton(
                                  context: context,
                                  text: 'Tidak Aktif',
                                  isSelected: _status == 'Tidak Aktif',
                                  onPressed: () {
                                    setState(() {
                                      _status = 'Tidak Aktif';
                                    });
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup dialog jika cancel
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _updateMahasiswa,
                  child: Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

// Helper method to create consistent status buttons
  Widget _buildStatusButton({
    required BuildContext context,
    required String text,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? Theme.of(context).primaryColor : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      child: Text(text),
    );
  }

// Helper widget untuk menampilkan field yang tidak bisa diubah
  Widget _buildReadOnlyTextField(
      TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        enabled:
            false, // Menandakan bahwa field ini hanya bisa ditampilkan, tidak bisa diubah
      ),
    );
  }

  // Helper widget to create text fields
  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If student details are provided, show the details screen
    if (widget.mahasiswaDetail != null) {
      return _buildMahasiswaDetail(widget.mahasiswaDetail!);
    }

    // If no details, show the student list
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
      body: ListView.builder(
        itemCount: _filteredMahasiswaList.length,
        itemBuilder: (context, index) {
          final mahasiswa = _filteredMahasiswaList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MahasiswaPage(
                      mahasiswaDetail: mahasiswa,
                    ),
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
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      'Prodi: ${mahasiswa['prodi']}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
