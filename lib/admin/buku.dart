import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:perpustakaan/util/config/config.dart';

class BukuPageAdmin extends StatefulWidget {
  @override
  _BukuPageAdminState createState() => _BukuPageAdminState();
}

class _BukuPageAdminState extends State<BukuPageAdmin> {
  List<dynamic> _books = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBooks(); // Ambil data buku saat halaman dimuat
  }

  // Fungsi untuk mengambil data buku
  Future<void> _fetchBooks({String? query}) async {
    try {
      var uri =
          Uri.http(AppConfig.API_HOST, '/perpustakaan/buku/get_buku.php', {
        'query': query ?? '',
      });
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> books = json.decode(response.body);
        setState(() {
          _books = books;
        });
      } else {
        throw Exception('Gagal mengambil data buku');
      }
    } catch (e) {
      print("Error fetching books: $e");
    }
  }

  // Fungsi untuk mengubah status buku dengan dialog konfirmasi
  Future<void> _updateBookStatus(
      dynamic bookId, String status, String bookTitle) async {
    // Menampilkan dialog konfirmasi sebelum mengubah status
    showDialog(
      context: context,
      barrierDismissible:
          false, // Tidak bisa menutup dialog dengan men-tap di luar
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Perubahan Status'),
          content: Text(
              'Apakah Anda yakin ingin mengubah status buku "$bookTitle" menjadi "$status"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Menutup dialog

                try {
                  var uri = Uri.http(AppConfig.API_HOST,
                      '/perpustakaan/buku/update_status_buku_admin.php');
                  final response = await http.post(uri, body: {
                    'id_buku': bookId.toString(),
                    'status': status,
                  });

                  if (response.statusCode == 200) {
                    final result = json.decode(response.body);
                    if (result['success'] == true) {
                      // Menampilkan dialog bahwa status berhasil diperbarui
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Sukses'),
                            content: Text(
                                'Status buku "$bookTitle" berhasil diperbarui menjadi "$status".'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Menutup dialog
                                  _fetchBooks(); // Refresh data buku setelah status diperbarui
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      throw Exception(result['message']);
                    }
                  } else {
                    throw Exception('Gagal memperbarui status buku');
                  }
                } catch (e) {
                  print("Error updating book status: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal memperbarui status buku')),
                  );
                }
              },
              child: Text('Ya'),
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
        elevation: 5,
        title: TextField(
          controller: _searchController,
          onChanged: (text) {
            _fetchBooks(query: text); // Menangani pencarian berdasarkan tags
          },
          decoration: InputDecoration(
            hintText: 'Cari Buku ',
            prefixIcon: const Icon(Icons.search, color: Colors.white),
            filled: true,
            fillColor: Colors.white70,
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: _fetchBooks,
          child: _books.isEmpty
              ? const Center(
                  child: Text("Tidak ada data buku",
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                )
              : ListView.builder(
                  itemCount: _books.length,
                  itemBuilder: (context, index) {
                    final book = _books[index];

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          book['judul_buku'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Penulis: ${book['penulis']}',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Status: ${book['status'] == 'Tersedia' ? 'Tersedia' : 'Di Pinjam'}',
                              style: TextStyle(
                                color: book['status'] == 'Tersedia'
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: Switch(
                          value: book['status'] == 'Tersedia',
                          onChanged: (bool value) {
                            final newStatus =
                                value ? 'Tersedia' : 'Di Pinjam'; // Ubah status
                            _updateBookStatus(book['id_buku'], newStatus,
                                book['judul_buku']); // Update status buku
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
