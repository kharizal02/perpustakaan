import 'package:flutter/material.dart';

class AddMahasiswaForm extends StatefulWidget {
  @override
  _AddMahasiswaFormState createState() => _AddMahasiswaFormState();
}

class _AddMahasiswaFormState extends State<AddMahasiswaForm> {
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
        title:const Text('Tambah Mahasiswa'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                  hintText: 'Masukkan Nama',
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
                  hintText: 'Masukkan Nrp',
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
                  hintText: 'Masukkan Status',
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
                  hintText: 'Masukkan Semester',
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
                controller: _deskripsiController,
                  decoration: InputDecoration(
                  hintText: 'Masukkan Tanggal Lahir',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
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