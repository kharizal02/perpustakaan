import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:perpustakaan/util/config/config.dart';

class BookComparisonPage extends StatefulWidget {
  final List<String> bookIds; // Menerima daftar ID buku yang dipilih

  BookComparisonPage({required this.bookIds});

  @override
  _BookComparisonPageState createState() => _BookComparisonPageState();
}

class _BookComparisonPageState extends State<BookComparisonPage> {
  List<dynamic> books = []; // Menyimpan detail buku yang akan dibandingkan

  @override
  void initState() {
    super.initState();
    _fetchBooksDetails(); // Memanggil fungsi untuk mendapatkan detail buku berdasarkan ID
  }

  // Fungsi untuk mengambil detail buku berdasarkan ID
  Future<void> _fetchBooksDetails() async {
    try {
      for (var bookId in widget.bookIds) {
        var uri =
            Uri.http(AppConfig.API_HOST, '/perpustakaan/buku/detail_buku.php', {
          'id_buku': bookId,
        });
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          var book = json.decode(response.body);
          setState(() {
            books.add(book); // Menambahkan buku ke dalam list
          });
        } else {
          throw Exception('Gagal mengambil detail buku');
        }
      }
    } catch (e) {
      print("Error fetching book details: $e");
    }
  }

  Widget _buildBookCard(dynamic book) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar Sampul Buku
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(
                        book['gambar_sampul'] != null
                            ? book['gambar_sampul']
                            : 'https://via.placeholder.com/150',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Judul Buku
                Text(
                  book['judul_buku'],
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 10),

                // Penulis dan Prodi
                Text(
                  'Penulis: ${book['penulis']}',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
                const SizedBox(height: 5),
                Text(
                  'Prodi: ${book['prodi']}',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
                const SizedBox(height: 5),
                Text(
                  'Tahun Terbit: ${book['tahun_terbit']}',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
                const SizedBox(height: 10),

                // Jumlah Halaman
                Text(
                  'Jumlah Halaman: ${book['jumlah_halaman']}',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
                const SizedBox(height: 15),

                // Tag Buku
                Text(
                  'Tag: ${book['tag']}',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
                const SizedBox(height: 20),

                // Status Buku
                Row(
                  children: [
                    Icon(
                      book['status'].toLowerCase() ==
                              'tersedia' // Cek jika status 'tersedia'
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: book['status'].toLowerCase() == 'tersedia'
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Status: ${book['status'].toLowerCase() == 'tersedia' ? 'Tersedia' : 'Dipinjam'}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: book['status'].toLowerCase() == 'tersedia'
                            ? Colors.green
                            : Colors.red,
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
                      Text(
                        book['deskripsi'] ?? 'Deskripsi tidak tersedia.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Perbandingan Buku"),
      ),
      body: books.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : (books.length < 2
              ? const Center(child: Text("Perbandingan membutuhkan 2 buku!"))
              : Column(
                  children: [
                    // Buku 1
                    _buildBookCard(books[0]),
                    const SizedBox(height: 16),

                    // Buku 2
                    _buildBookCard(books[1]),
                  ],
                )),
    );
  }
}
