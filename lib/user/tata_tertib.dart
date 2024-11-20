import 'package:flutter/material.dart';

class TataTertibPage extends StatefulWidget {
  const TataTertibPage({super.key});

  @override
  _TataTertibPageState createState() => _TataTertibPageState();
}

class _TataTertibPageState extends State<TataTertibPage> {
  // State variables for the checkboxes
  bool _isCheckedAgree = false;
  bool _isCheckedRead = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Blue Arc
          ClipPath(
            clipper: ArcClipper(),
            child: Container(
              height: 100,
              color: Colors.blue,
              alignment: Alignment.center,
              child: const Text(
                'TATA TERTIB',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                ),
              ),
            ),
          ),

          // Terms Text Content in Scrollable Container
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Text(
                    'Tata Tertib Penggunaan Aplikasi Perpustakaan\n\n' +
                        '1. *Pendaftaran dan Keanggotaan*\n' +
                        '- Setiap pengguna aplikasi perpustakaan wajib memiliki akun yang terdaftar dan terverifikasi.\n' +
                        '- Informasi yang diberikan saat mendaftar harus valid, lengkap, dan terbaru.\n' +
                        '- Pengguna bertanggung jawab untuk menjaga kerahasiaan akun dan tidak membagikan akses kepada pihak lain.\n\n' +
                        '2. *Pencarian dan Pemesanan Buku*\n' +
                        '- Pengguna dapat mencari dan memesan buku yang tersedia dalam koleksi perpustakaan melalui aplikasi.\n' +
                        '- Jumlah maksimum pemesanan dan durasi peminjaman buku akan ditentukan oleh kebijakan perpustakaan.\n' +
                        '- Apabila buku yang dipesan sudah melewati batas waktu peminjaman, maka akan dikenakan denda sesuai dengan kebijakan perpustakaan.\n\n' +
                        '3. *Pengembalian Buku*\n' +
                        '- Pengguna harus mengembalikan buku yang dipinjam tepat waktu sesuai jadwal yang ditentukan.\n' +
                        '- Jika pengguna membutuhkan waktu tambahan, mereka bisa memperpanjang peminjaman melalui aplikasi selama buku tersebut tidak sedang dipesan oleh pengguna lain.\n\n' +
                        '4. *Keterlambatan dan Denda*\n' +
                        '- Pengguna yang mengembalikan buku melebihi batas waktu yang ditentukan akan dikenakan denda sesuai kebijakan perpustakaan.\n' +
                        '- Denda keterlambatan akan otomatis terakumulasi dalam akun pengguna di aplikasi.\n\n' +
                        '5. *Perawatan Buku*\n' +
                        '- Pengguna bertanggung jawab untuk menjaga kondisi buku yang dipinjam. Kerusakan atau kehilangan buku akan dikenakan sanksi sesuai dengan kebijakan perpustakaan.\n' +
                        '- Jika terjadi kerusakan pada buku, pengguna diharapkan melaporkan ke pihak perpustakaan melalui aplikasi atau langsung ke petugas.\n\n' +
                        '6. *Etika Penggunaan Aplikasi*\n' +
                        '- Pengguna diharapkan menjaga etika dalam menggunakan aplikasi, termasuk menghindari tindakan spam, penyalahgunaan data, atau tindakan yang mengganggu pengguna lain.\n' +
                        '- Setiap laporan pelanggaran terhadap tata tertib ini dapat mengakibatkan pembatasan akses hingga penonaktifan akun.\n\n' +
                        '7. *Pemeliharaan dan Pembaruan Sistem*\n' +
                        '- Aplikasi akan mengalami pemeliharaan dan pembaruan secara berkala untuk meningkatkan kualitas layanan. Selama proses ini, akses ke beberapa fitur mungkin terganggu untuk sementara waktu.\n' +
                        '- Informasi mengenai pemeliharaan atau pembaruan akan diumumkan terlebih dahulu melalui notifikasi aplikasi.\n\n' +
                        '8. *Bantuan dan Pengaduan*\n' +
                        '- Jika mengalami kesulitan atau ingin mengajukan pengaduan terkait layanan, pengguna dapat menghubungi layanan bantuan melalui fitur yang tersedia di aplikasi.\n\n' +
                        '*Catatan Penting*\n' +
                        'Dengan menggunakan aplikasi perpustakaan ini, pengguna dianggap telah membaca, memahami, dan menyetujui tata tertib yang berlaku. Tata tertib ini dapat berubah sewaktu-waktu sesuai kebijakan perpustakaan.\n\n' +
                        '---\n' +
                        'Semoga tata tertib ini membantu dalam mengelola penggunaan aplikasi perpustakaan dengan lebih tertib dan tertata.',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
          ),

          // Checkbox and Continue Button
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              children: [
                // Checkbox for "Saya telah membaca"
                Row(
                  children: [
                    Checkbox(
                      value: _isCheckedRead,
                      onChanged: (bool? value) {
                        setState(() {
                          _isCheckedRead = value ?? false;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'Saya telah membaca syarat dan ketentuan diatas',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),

                // Checkbox for "Saya menyetujui segala ketentuan"
                Row(
                  children: [
                    Checkbox(
                      value: _isCheckedAgree,
                      onChanged: (bool? value) {
                        setState(() {
                          _isCheckedAgree = value ?? false;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'Saya menyetujui segala ketentuan diatas',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_isCheckedRead && _isCheckedAgree)
                        ? () {
                            Navigator.pushNamed(context, '/home');
                          }
                        : null, // Disable button if checkboxes are not checked
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'LANJUTKAN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Blue Arc
          ClipPath(
            clipper: InvertedArcClipper(),
            child: Container(
              height: 100,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Clipper for the Top Arc
class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

// Custom Clipper for the Inverted Bottom Arc
class InvertedArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 30);
    path.quadraticBezierTo(size.width / 2, 0, size.width, 30);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
