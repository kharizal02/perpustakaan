import 'package:flutter/material.dart';

class MahasiswaDetailPage extends StatelessWidget {
  final String nama;
  final String nrp;
  final String status;
  final String prodi;
  final String semester;
  final String tanggalLahir;

  const MahasiswaDetailPage({
    super.key,
    required this.nama,
    required this.nrp,
    required this.status,
    required this.prodi,
    required this.semester,
    required this.tanggalLahir,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Detail Mahasiswa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('Nama', nama),
            _buildDetailItem('NRP', nrp),
            _buildDetailItem('Status', status),
            _buildDetailItem('Prodi', prodi),
            _buildDetailItem('Semester', semester),
            _buildDetailItem('Tanggal Lahir', tanggalLahir),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}