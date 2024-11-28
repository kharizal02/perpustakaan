import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:perpustakaan/util/config/config.dart';

class BookDetailPage extends StatefulWidget {
  final String bookId;

  BookDetailPage({required this.bookId});

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late Future<Map<String, dynamic>> _bookDetail;

  @override
  void initState() {
    super.initState();
    _bookDetail = _fetchBookDetail(widget.bookId);
  }

  Future<Map<String, dynamic>> _fetchBookDetail(String bookId) async {
    try {
      var uri =
          Uri.http(AppConfig.API_HOST, '/perpustakaan/buku/detail_buku.php', {
        'id_buku': bookId,
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal mengambil detail buku');
      }
    } catch (e) {
      print("Error fetching book details: $e");
      return {};
    }
  }

  Future<void> _deleteBook(String bookId) async {
    try {
      var uri =
          Uri.http(AppConfig.API_HOST, '/perpustakaan/buku/hapus_buku.php', {
        'id_buku': bookId,
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['success']) {
          // Berhasil menghapus buku
          _showResultDialog(
            title: "Sukses",
            message: "Buku berhasil dihapus.",
            success: true,
          );
        } else {
          throw Exception('Gagal menghapus buku');
        }
      } else {
        throw Exception('Gagal menghapus buku');
      }
    } catch (e) {
      print("Error deleting book: $e");
      _showResultDialog(
        title: "Kesalahan",
        message: "Terjadi kesalahan saat menghapus buku.",
        success: false,
      );
    }
  }

  void _showResultDialog(
      {required String title, required String message, required bool success}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                if (success) {
                  // Pop dengan result true untuk mengindikasikan refresh
                  Navigator.of(context)
                      .pop(true); // Kembali ke halaman sebelumnya
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(String bookId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apakah Anda yakin ingin menghapus buku ini?"),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Hapus'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteBook(bookId);
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
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Detail Buku"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _bookDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Terjadi kesalahan"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Buku tidak ditemukan"));
          }

          var book = snapshot.data!;
          bool isAvailable = book['status'].toLowerCase() == 'tersedia';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // Judul Buku dan ID Buku
                        Text(
                          book['judul_buku'],
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 5),

                        // ID Buku
                        Text(
                          'ID Buku: ${book['id_buku']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Penulis dan Prodi
                        Text(
                          'Penulis: ${book['penulis']}',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Prodi: ${book['prodi']}',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Tahun Terbit: ${book['tahun_terbit']}',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 10),

                        // Jumlah Halaman
                        Text(
                          'Jumlah Halaman: ${book['jumlah_halaman']}',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 15),

                        // Tag Buku
                        Text(
                          'Tag: ${book['tag']}',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 20),

                        // Status Buku
                        Row(
                          children: [
                            Icon(
                              isAvailable ? Icons.check_circle : Icons.cancel,
                              color: isAvailable ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Status: ${isAvailable ? 'Tersedia' : 'Dipinjam'}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isAvailable ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Deskripsi
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Deskripsi:',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 150,
                                child: SingleChildScrollView(
                                  child: Text(
                                    book['deskripsi'] ??
                                        'Deskripsi tidak tersedia.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Tombol Hapus Buku
                Visibility(
                  visible: isAvailable,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Warna tombol merah
                      ),
                      onPressed: () {
                        _showConfirmationDialog(widget.bookId);
                      },
                      child: const Text(
                        "Hapus Buku",
                        style: TextStyle(
                          color: Colors.white, // Warna tulisan menjadi putih
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
