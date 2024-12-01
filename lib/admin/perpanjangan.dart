import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:e_libs/util/config/config.dart';

class PerpanjanganPage extends StatefulWidget {
  @override
  _PerpanjanganPageState createState() => _PerpanjanganPageState();
}

class _PerpanjanganPageState extends State<PerpanjanganPage> {
  List<Map<String, dynamic>> perpanjanganData = [];
  bool _isLoading = true;

  Future<void> fetchPerpanjanganData() async {
    try {
      var uri = Uri.http(
          AppConfig.API_HOST, '/perpustakaan/booking/get_perpanjangan.php');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['status'] == 'success') {
          setState(() {
            perpanjanganData = List<Map<String, dynamic>>.from(data['data']);
            _isLoading = false;
          });
        } else {
          _showErrorDialog('Data perpanjangan tidak ditemukan.');
        }
      } else {
        _showErrorDialog('Gagal mengambil data dari server.');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Terjadi kesalahan: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error', style: TextStyle(color: Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Future<void> updateTanggalPengembalian(
      String idBooking, String newDate) async {
    try {
      var updateUri = Uri.http(
          AppConfig.API_HOST, '/perpustakaan/booking/update_pengembalian.php');
      var updateResponse = await http.post(updateUri, body: {
        'id_booking': idBooking,
        'tanggal_pengembalian': newDate,
      });

      if (updateResponse.statusCode == 200) {
        var updateData = json.decode(updateResponse.body);
        if (updateData['status'] == 'success') {
          var deleteUri = Uri.http(AppConfig.API_HOST,
              '/perpustakaan/booking/delete_perpanjangan.php');
          var deleteResponse = await http.post(deleteUri, body: {
            'id_booking': idBooking,
          });

          if (deleteResponse.statusCode == 200) {
            var deleteData = json.decode(deleteResponse.body);
            if (deleteData['status'] == 'success') {
              setState(() {
                perpanjanganData
                    .removeWhere((item) => item['id_booking'] == idBooking);
              });
              _showSuccessDialog('Berhasil memperpanjang pengembalian.');
            } else {
              _showErrorDialog('Gagal menghapus permintaan perpanjangan.');
            }
          } else {
            _showErrorDialog(
                'Gagal menghubungi server saat menghapus permintaan.');
          }
        } else {
          _showErrorDialog('Gagal memperbarui tanggal pengembalian.');
        }
      } else {
        _showErrorDialog('Gagal menghubungi server.');
      }
    } catch (e) {
      _showErrorDialog('Terjadi kesalahan: $e');
    }
  }

  // Fungsi untuk menolak perpanjangan dan mengirimkan notifikasi
  Future<void> _tolakPerpanjangan(String idBooking) async {
    try {
      var uri = Uri.http(
          AppConfig.API_HOST, '/perpustakaan/booking/reject_perpanjangan.php');
      final response = await http.post(uri, body: {
        'id_booking': idBooking,
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['status'] == 'success') {
          setState(() {
            // Hapus permintaan perpanjangan yang ditolak dari daftar
            perpanjanganData
                .removeWhere((item) => item['id_booking'] == idBooking);
          });
          _showSuccessDialog('Permintaan perpanjangan telah ditolak.');
        } else {
          _showErrorDialog('Gagal menolak permintaan perpanjangan.');
        }
      } else {
        _showErrorDialog('Gagal menghubungi server.');
      }
    } catch (e) {
      _showErrorDialog('Terjadi kesalahan: $e');
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Sukses', style: TextStyle(color: Colors.green)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchPerpanjanganData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: perpanjanganData.isEmpty
                  ? Center(
                      child: Text(
                        'Tidak ada permintaan perpanjangan',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: perpanjanganData.length,
                      itemBuilder: (ctx, index) {
                        var perpanjangan = perpanjanganData[index];
                        String tanggalPerpanjangan =
                            perpanjangan['tanggal_perpanjangan'];

                        return Card(
                          elevation: 6,
                          shadowColor: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  perpanjangan['judul_buku'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'ID Booking: ${perpanjangan['id_booking']}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                                Text(
                                  'Nama: ${perpanjangan['nama']}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                                Text(
                                  'NRP: ${perpanjangan['nrp']}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Tanggal Booking: ${perpanjangan['tanggal_booking']}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Tanggal Pengembalian: ${perpanjangan['tanggal_pengembalian']}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Tanggal Perpanjangan: $tanggalPerpanjangan',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Alasan: ${perpanjangan['alasan']}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[800]),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        updateTanggalPengembalian(
                                          perpanjangan['id_booking'].toString(),
                                          tanggalPerpanjangan,
                                        );
                                      },
                                      child: Text(
                                        'Setuju',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        _tolakPerpanjangan(
                                          perpanjangan['id_booking'].toString(),
                                        );
                                      },
                                      child: Text(
                                        'Tolak',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
