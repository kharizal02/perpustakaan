import 'package:flutter/material.dart';

class PerpanjanganPage extends StatelessWidget {
  // Dummy booking data
  final String idBooking = "B001";
  final String idBuku = "B001";
  final String judulBuku = "Flutter for Beginners";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perpanjangan Buku',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0977F9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the card
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Padding inside the card
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID Booking: $idBooking',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ID Buku: $idBuku',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Judul Buku: $judulBuku',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(
                          height: 16), // Space before the description
                      const Text(
                        'Alasan Perpanjangan:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      const TextField(
                        maxLines: 5, // Number of lines for the text area
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Masukkan alasan perpanjangan...',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // Space before the button
                  Center(
                    // Center the button
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle extension action
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 40),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Ajukan Perpanjangan',
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
          ),
        ),
      ),
    );
  }
}
