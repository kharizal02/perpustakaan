import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:perpustakaan/util/config/config.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ListPeminjamanPage extends StatefulWidget {
  @override
  _ListPeminjamanPageState createState() => _ListPeminjamanPageState();
}

class _ListPeminjamanPageState extends State<ListPeminjamanPage> {
  String? nrp;
  List<dynamic> peminjamanData = [];
  List<dynamic> filteredPeminjamanData = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getNrp();
  }

  Future<void> _getNrp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nrp = prefs.getString('nrp');
    });

    // Fetch data even if nrp is null
    _fetchPeminjaman(nrp);
  }

  // Update _fetchPeminjaman to handle null nrp
  Future<void> _fetchPeminjaman(String? nrp) async {
    try {
      var uri = Uri.http(
        AppConfig.API_HOST,
        '/perpustakaan/booking/get_booking_admin.php',
      );

      final response = await http.post(uri, headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        if (nrp != null) 'nrp': nrp, // Only send nrp if it's not null
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['status'] == 'success') {
          setState(() {
            peminjamanData = data['data'] ?? [];
            filteredPeminjamanData = peminjamanData;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          _showErrorDialog('Failed to load data.');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load data.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog('Error: ${e.toString()}');
    }
  }

  void _filterPeminjamanData(String query) {
    setState(() {
      filteredPeminjamanData = peminjamanData.where((peminjaman) {
        return peminjaman['judul_buku']
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            peminjaman['id_booking'].toString().contains(query) ||
            (peminjaman['nama'] != null &&
                peminjaman['nama']
                    .toLowerCase()
                    .contains(query.toLowerCase())) ||
            (peminjaman['nrp'] != null &&
                peminjaman['nrp'].toString().contains(query));
      }).toList();
    });
  }

  void _confirmDelete(dynamic idBooking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text(
              'Apakah Anda yakin ingin menghapus data peminjaman ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _hapusPeminjaman(idBooking); // Proceed to delete
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _hapusPeminjaman(dynamic idBooking) async {
    try {
      String bookingId = idBooking.toString();

      var uri = Uri.http(
          AppConfig.API_HOST, '/perpustakaan/booking/delete_booking.php');

      print('Deleting booking with ID: $bookingId'); // Debug log

      final response = await http.post(uri, headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      }, body: {
        'id_booking': bookingId
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print('Response: $data'); // Debug log

        if (data['status'] == 'success') {
          setState(() {
            peminjamanData.removeWhere(
                (item) => item['id_booking'].toString() == bookingId);
            filteredPeminjamanData = peminjamanData;
          });
          _showSuccessDialog('Peminjaman berhasil dihapus.');
        } else {
          _showErrorDialog(data['message'] ?? 'Gagal menghapus peminjaman.');
        }
      } else {
        throw Exception('Failed to delete data.');
      }
    } catch (e) {
      print('Error: $e'); // Debug log
      _showErrorDialog('Error: ${e.toString()}');
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sukses'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            onChanged: (query) => _filterPeminjamanData(query),
            decoration: InputDecoration(
              hintText: 'Cari Buku atau ID Peminjaman...',
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredPeminjamanData.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada peminjaman untuk ditampilkan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  itemCount: filteredPeminjamanData.length,
                  itemBuilder: (context, index) {
                    var peminjaman = filteredPeminjamanData[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Icon(Icons.book, color: Colors.blueAccent),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ID Booking: ${peminjaman['id_booking']}',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              peminjaman['judul_buku'] ?? 'No Title',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Nama Peminjam: ${peminjaman['nama']}',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'NRP: ${peminjaman['nrp']}',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text(
                              'Tanggal Peminjaman: ${peminjaman['tanggal_booking']}',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Tenggat Pengembalian: ${peminjaman['tanggal_pengembalian']}',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                            if (peminjaman['denda'] != 0) // Cek jika denda > 0
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  'Denda: Rp${peminjaman['denda']}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _confirmDelete(peminjaman['id_booking']);
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
