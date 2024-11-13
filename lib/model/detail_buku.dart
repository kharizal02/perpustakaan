import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:perpustakaan/util/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:perpustakaan/model/booking.dart';

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

  // Fungsi untuk mengarahkan ke halaman booking dengan mengambil data dari SharedPreferences
  Future<void> _navigateToBookingPage(String judulBuku) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String nrp = prefs.getString('nrp') ?? 'NRP tidak ditemukan';
    String nama = prefs.getString('nama') ?? 'Nama tidak ditemukan';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingPage(
          nrp: nrp,
          nama: nama,
          judulBuku: judulBuku,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Detail Buku"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _bookDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Buku tidak ditemukan"));
          }

          var book = snapshot.data!;

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
                        // Gambar Sampul Buku
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: NetworkImage(book['gambar_sampul'] ??
                                  'https://via.placeholder.com/150'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Judul Buku
                        Text(
                          book['judul_buku'],
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(height: 10),

                        // Penulis dan Prodi
                        Text(
                          'Penulis: ${book['penulis']}',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Prodi: ${book['prodi']}',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Tahun Terbit: ${book['tahun_terbit']}',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 10),

                        // Jumlah Halaman
                        Text(
                          'Jumlah Halaman: ${book['jumlah_halaman']}',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 15),

                        // Tag Buku
                        Text(
                          'Tag: ${book['tag']}',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 20),

                        // Status Buku
                        Row(
                          children: [
                            Icon(
                              book['status'] == '1'
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: book['status'] == '1'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Status: ${book['status'] == '1' ? 'Tersedia' : 'Dipinjam'}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: book['status'] == '1'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Deskripsi
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Deskripsi:',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
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
                SizedBox(height: 20),
                // Tombol Booking
                ElevatedButton(
                  onPressed: () {
                    _navigateToBookingPage(book['judul_buku']);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Latar belakang merah
                    foregroundColor: Colors.white, // Warna teks putih
                    elevation:
                        10, // Memberikan bayangan untuk efek tombol yang lebih mewah
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15), // Membuat sudut tombol melengkung
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal:
                            24), // Menambah padding untuk ukuran tombol lebih besar
                  ),
                  child: Text(
                    'Booking Buku',
                    style: TextStyle(
                      fontSize:
                          18, // Menambah ukuran font untuk tampilan lebih besar
                      fontWeight: FontWeight
                          .bold, // Memberikan efek teks yang lebih tebal
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
