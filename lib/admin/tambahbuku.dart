import 'package:flutter/material.dart';

class TambahBukuPage extends StatefulWidget {
  @override
  TambahBukuPageState createState() => TambahBukuPageState();
}

class TambahBukuPageState extends State<TambahBukuPage> {
 final _judulController = TextEditingController();
  final _penulisController = TextEditingController();
  final _prodiController = TextEditingController();
  final _tahunTerbitController = TextEditingController();
  final _deskripsiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color(0xFF42A5F5),
        title:const Text('Tambah Buku'),
        ),
      body: Padding(
        padding: const EdgeInsets.only(left: 50, right:50),
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _judulController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Masukkan judul buku',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
            SizedBox(height: 20),
           Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _penulisController,
                decoration: InputDecoration(
                  hintText: 'Masukkan Penulis',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _prodiController,
                decoration: InputDecoration(
                  hintText: 'Masukkan Prodi',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _tahunTerbitController,
                decoration: InputDecoration(
                  hintText: 'Masukkan Tahun Terbit',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(height: 250,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _deskripsiController,
                maxLines: null, // Menjadikan input teks multi-baris
                decoration: InputDecoration(
                  hintText: 'Masukkan Deskripsi',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
              ),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print('Judul: ${_judulController.text}');
                print('Penulis: ${_penulisController.text}');
                print('Prodi: ${_prodiController.text}');
                print('Tahun Terbit: ${_tahunTerbitController.text}');
                print('Deskripsi: ${_deskripsiController.text}');
              },
               style: ElevatedButton.styleFrom(
               backgroundColor: Colors.blue),
              child: const Text('Tambah',
              style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}