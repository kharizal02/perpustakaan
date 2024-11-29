import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:perpustakaan/util/config/config.dart';
import 'package:perpustakaan/admin/detail_buku.dart';

class BukuPageAdmin extends StatefulWidget {
  @override
  _BukuPageAdminState createState() => _BukuPageAdminState();
}

class _BukuPageAdminState extends State<BukuPageAdmin> {
  List<dynamic> _books = [];
  TextEditingController _searchController = TextEditingController();
  bool _isSelectMode = false;
  List<String> selectedBooks = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks({String? query}) async {
  setState(() {
    _isLoading = true;
  });

  try {
    var uri = Uri.http(AppConfig.API_HOST, '/perpustakaan/buku/get_buku.php', {
      'query': query ?? '',
    });
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> books = json.decode(response.body);

      // Sorting books: 'tersedia' di atas, lainnya di bawah
      books.sort((a, b) {
        String statusA = a['status'].toLowerCase();
        String statusB = b['status'].toLowerCase();
        if (statusA == 'tersedia' && statusB != 'tersedia') {
          return -1; // 'tersedia' lebih tinggi
        } else if (statusA != 'tersedia' && statusB == 'tersedia') {
          return 1; // 'dipinjam' lebih rendah
        }
        return 0; // status sama, tidak diubah
      });

      setState(() {
        _books = books;
        _isLoading = false;
      });
    } else {
      throw Exception('Gagal mengambil data buku');
    }
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}


  void _toggleSelectMode() {
    setState(() {
      _isSelectMode = !_isSelectMode;
      if (!_isSelectMode) selectedBooks.clear();
    });
  }

  void _onBookSelected(dynamic bookId) {
    setState(() {
      String bookIdStr = bookId.toString();
      if (selectedBooks.contains(bookIdStr)) {
        selectedBooks.remove(bookIdStr);
      } else {
        selectedBooks.add(bookIdStr);
      }
    });
  }

  void _navigateToDetail(String bookId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailPage(bookId: bookId),
      ),
    );

    if (result == true) {
      _fetchBooks(); // Refresh data jika buku berhasil dihapus
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
            _fetchBooks(query: text);
          },
          decoration: InputDecoration(
            hintText: 'Cari Buku (Judul, Penulis, Prodi, Tahun Terbit)',
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
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : _books.isEmpty
                  ? Center(
                      child: Text("Tidak ada data buku",
                          style: TextStyle(fontSize: 18, color: Colors.grey)))
                  : ListView.builder(
                      itemCount: _books.length,
                      itemBuilder: (context, index) {
                        final book = _books[index];
                        String bookIdStr = book['id_buku'].toString();
                        bool isSelected = selectedBooks.contains(bookIdStr);

                        // Status dan Warna
                        final isAvailable =
                            book['status'].toLowerCase() == 'tersedia';
                        final statusText =
                            isAvailable ? 'Tersedia' : 'Dipinjam';
                        final statusColor =
                            isAvailable ? Colors.green : Colors.red;

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
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
                                  'Prodi: ${book['prodi']}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Tahun Terbit: ${book['tahun_terbit']}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Status: $statusText',
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Icon(
                              isAvailable ? Icons.check_circle : Icons.cancel,
                              color: statusColor,
                            ),
                            onTap: () {
                              final bookId = book['id_buku'];
                              if (!_isSelectMode && bookId != null) {
                                _navigateToDetail(bookId.toString());
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
    );
  }
}
