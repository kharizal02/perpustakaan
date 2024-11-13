class Peminjaman {
  final int idBooking;
  final String nrp;
  final String nama;
  final String judulBuku;
  final String tanggalBooking;
  final String tanggalPengembalian;

  Peminjaman({
    required this.idBooking,
    required this.nrp,
    required this.nama,
    required this.judulBuku,
    required this.tanggalBooking,
    required this.tanggalPengembalian,
  });

  // Fungsi untuk membuat objek Peminjaman dari JSON
  factory Peminjaman.fromJson(Map<String, dynamic> json) {
    return Peminjaman(
      idBooking: json['id_booking'],
      nrp: json['nrp'],
      nama: json['nama'],
      judulBuku: json['judul_buku'],
      tanggalBooking: json['tanggal_booking'],
      tanggalPengembalian: json['tanggal_pengembalian'],
    );
  }
}
