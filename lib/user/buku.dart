import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_libs/util/config/config.dart';
import 'package:e_libs/user/detail_buku.dart';
import 'package:e_libs/user/bandingkan_buku.dart';

class BukuPage extends StatefulWidget {
  @override
  _BukuPageState createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
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
      var uri =
          Uri.http(AppConfig.API_HOST, '/perpustakaan/buku/get_buku.php', {
        'query': query ?? '',
      });
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> books = json.decode(response.body);

        books.sort((a, b) {
          String statusA = a['status'].toLowerCase();
          String statusB = b['status'].toLowerCase();
          int totalPeminjamanA = a['total_peminjaman'] ?? 0;
          int totalPeminjamanB = b['total_peminjaman'] ?? 0;

          // Pertama, urutkan berdasarkan status. Buku 'tersedia' harus di atas buku 'dipinjam'
          if (statusA == 'tersedia' && statusB != 'tersedia') {
            return -1; // Buku 'tersedia' di atas
          } else if (statusA != 'tersedia' && statusB == 'tersedia') {
            return 1; // Buku 'dipinjam' di bawah
          }

          // Kedua, jika status sama, urutkan berdasarkan jumlah peminjaman (yang lebih banyak di atas)
          return totalPeminjamanB.compareTo(
              totalPeminjamanA); // Urutkan berdasarkan peminjaman terbanyak
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
      if (!_isSelectMode)
        selectedBooks.clear(); // Clear selection when exiting select mode
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

  void _compareBooks() {
    if (selectedBooks.length == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookComparisonPage(
            bookIds: selectedBooks,
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
            _fetchBooks(query: text);
          },
          decoration: InputDecoration(
            hintText: 'Cari Buku',
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
        leading: null, // Ensures no back button in the AppBar
        actions: [
          IconButton(
            icon: Icon(
              _isSelectMode ? Icons.close : Icons.check_box,
              color: Colors.white,
            ),
            onPressed: _toggleSelectMode,
          ),
        ],
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

                        // Improved status handling
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
                            trailing: book['total_peminjaman'] >= 3
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.bookmark,
                                        size: 18,
                                        color: Colors.blueGrey,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '${book['total_peminjaman']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                            onTap: () {
                              final bookId = book['id_buku'];
                              if (!_isSelectMode && bookId != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookDetailPage(
                                        bookId: bookId.toString()),
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
              child: const Icon(Icons.compare_arrows, color: Colors.white),
            )
          : null,
    );
  }
}
