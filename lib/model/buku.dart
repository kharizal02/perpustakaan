import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:perpustakaan/util/config/config.dart';
import 'package:perpustakaan/model/detail_buku.dart';
import 'package:perpustakaan/model/bandingkan_buku.dart';

class BukuPage extends StatefulWidget {
  @override
  _BukuPageState createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  List<dynamic> _books = [];
  TextEditingController _searchController = TextEditingController();
  bool _isSelectMode = false; // Menyimpan status mode checkbox
  List<String> selectedBooks = []; // Menyimpan ID buku yang dipilih

  @override
  void initState() {
    super.initState();
    _fetchBooks(); // Ambil data buku saat halaman dimuat
  }

  // Fungsi untuk mengambil buku berdasarkan tag pencarian
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
          _books = books; // Mengubah data buku yang diterima menjadi list
        });
      } else {
        throw Exception('Gagal mengambil data buku');
      }
    } catch (e) {
      print("Error fetching books: $e");
    }
  }

  // Fungsi untuk mengubah status mode checkbox
  void _toggleSelectMode() {
    setState(() {
      _isSelectMode = !_isSelectMode;
      if (!_isSelectMode)
        selectedBooks.clear(); // Kosongkan pilihan jika mode dimatikan
    });
  }

  // Fungsi untuk menangani checkbox yang dipilih
  void _onBookSelected(dynamic bookId) {
    setState(() {
      String bookIdStr = bookId.toString(); // Pastikan ID adalah String
      if (selectedBooks.contains(bookIdStr)) {
        selectedBooks.remove(bookIdStr);
      } else {
        selectedBooks.add(bookIdStr);
      }
    });
  }

  // Fungsi untuk mengarahkan ke halaman perbandingan buku
  void _compareBooks() {
    if (selectedBooks.length == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookComparisonPage(
            bookIds: selectedBooks, // Mengirim ID buku yang dipilih
          ),
        ),
      );
    }
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
            prefixIcon: Icon(Icons.search, color: Colors.white),
            filled: true,
            fillColor: Colors.white70,
            contentPadding: EdgeInsets.symmetric(vertical: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              _isSelectMode ? Icons.close : Icons.check_box,
              color: Colors.white,
            ),
            onPressed: _toggleSelectMode, // Ubah status mode checkbox
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: () =>
              _fetchBooks(), // Fitur refresh ketika user pull to refresh
          child: _books.isEmpty
              ? Center(
                  child: Text("Tidak ada data buku",
                      style: TextStyle(fontSize: 18, color: Colors.grey)))
              : ListView.builder(
                  itemCount: _books.length,
                  itemBuilder: (context, index) {
                    final book = _books[index];
                    String bookIdStr =
                        book['id_buku'].toString(); // Pastikan ID adalah String
                    bool isSelected = selectedBooks.contains(bookIdStr);

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: _isSelectMode
                            ? Checkbox(
                                value: isSelected,
                                onChanged: (bool? value) {
                                  _onBookSelected(book['id_buku']);
                                },
                              )
                            : null,
                        title: Text(
                          book['judul_buku'],
                          style: TextStyle(
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
                            SizedBox(height: 5),
                            Text(
                              'Tahun Terbit: ${book['tahun_terbit']}',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[600]),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Status: ${book['status'] == '1' ? 'Tersedia' : 'Dipinjam'}',
                              style: TextStyle(
                                color: book['status'] == '1'
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: Icon(
                          book['status'] == '1'
                              ? Icons.check_circle
                              : Icons.cancel,
                          color:
                              book['status'] == '1' ? Colors.green : Colors.red,
                        ),
                        onTap: () {
                          final bookId = book['id_buku'];
                          if (!_isSelectMode && bookId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BookDetailPage(bookId: bookId.toString()),
                              ),
                            );
                          } else if (_isSelectMode) {
                            _onBookSelected(book['id_buku']);
                          }
                        },
                      ),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: _isSelectMode && selectedBooks.length == 2
          ? FloatingActionButton(
              onPressed: _compareBooks,
              backgroundColor: Colors.red,
              child: Icon(Icons.compare_arrows, color: Colors.white),
            )
          : null, // Tombol hanya muncul jika dua buku dipilih
    );
  }
}
