import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Library untuk format tanggal
import 'package:e_libs/util/config/config.dart'; // Gantilah dengan path yang sesuai

class RiwayatBookingPage extends StatefulWidget {
  @override
  _RiwayatBookingPageState createState() => _RiwayatBookingPageState();
}

class _RiwayatBookingPageState extends State<RiwayatBookingPage> {
  List<dynamic> _bookingHistory = [];
  List<dynamic> _filteredBookingHistory = [];
  bool _isLoading = false;
  TextEditingController _searchController = TextEditingController();
  DateTime? _selectedDate; // Tanggal yang dipilih oleh pengguna

  @override
  void initState() {
    super.initState();
    _fetchBookingHistory();
    _searchController.addListener(_filterBookingHistory);
  }

  Future<void> _fetchBookingHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var uri = Uri.http(
          AppConfig.API_HOST, '/perpustakaan/booking/riwayat_booking.php');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> bookingHistory = json.decode(response.body);
        print('Data Booking Diterima: $bookingHistory');
        setState(() {
          _bookingHistory = bookingHistory;
          _filteredBookingHistory = bookingHistory;
          _isLoading = false;
        });
      } else {
        throw Exception('Gagal mengambil riwayat booking');
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

  // Function to filter the booking history based on the search query
  void _filterBookingHistory() {
    String query = _searchController.text.toLowerCase();
    List<dynamic> filteredList = _bookingHistory.where((booking) {
      return booking['id_booking'].toString().toLowerCase().contains(query) ||
          booking['nrp'].toString().toLowerCase().contains(query) ||
          booking['nama'].toLowerCase().contains(query) ||
          booking['judul_buku'].toLowerCase().contains(query);
    }).toList();

    setState(() {
      _filteredBookingHistory = filteredList;
    });
  }

  // Function to show a date picker and filter by return date
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _filterByReturnDate();
      });
    }
  }

  // Function to filter the booking history by the selected return date
  void _filterByReturnDate() {
    if (_selectedDate == null) return;

    // Format tanggal yang dipilih oleh pengguna
    String formattedSelectedDate =
        DateFormat('yyyy-MM-dd').format(_selectedDate!);
    print(
        'Tanggal yang dipilih oleh pengguna (formatted): $formattedSelectedDate'); // Debugging tanggal

    List<dynamic> filteredList = _bookingHistory.where((booking) {
      String bookingDate = booking['tanggal_kembali'];

      // Cek format tanggal yang diterima dari server
      print('Tanggal Kembali dari Data (sebelum parsing): $bookingDate');

      try {
        // Parsing tanggal dari data JSON
        DateTime parsedDate = DateTime.parse(bookingDate);
        String formattedBookingDate =
            DateFormat('yyyy-MM-dd').format(parsedDate);
        print('Tanggal Kembali dari Data (formatted): $formattedBookingDate');

        // Bandingkan dengan tanggal yang dipilih oleh pengguna
        return formattedBookingDate == formattedSelectedDate;
      } catch (e) {
        print('Error parsing tanggal_kembali: $e');
        return false;
      }
    }).toList();

    setState(() {
      _filteredBookingHistory = filteredList;
      print(
          'Jumlah data yang cocok: ${filteredList.length}'); // Debugging jumlah data
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            _filterBookingHistory(); // Use the filter function directly
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
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.white),
            onPressed: _pickDate,
          ),
        ],
        automaticallyImplyLeading: false, // Hides the back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _filteredBookingHistory.isEmpty
                ? Center(
                    child: Text(
                      "Tidak ada riwayat booking yang cocok",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredBookingHistory.length,
                    itemBuilder: (context, index) {
                      final booking = _filteredBookingHistory[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            'Buku: ${booking['judul_buku']}',
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
                                'ID Booking: ${booking['id_booking']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Nama Peminjam: ${booking['nama']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'NRP: ${booking['nrp']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Tanggal Booking: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(booking['tanggal_booking']))}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Tanggal Kembali: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(booking['tanggal_kembali']))}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
