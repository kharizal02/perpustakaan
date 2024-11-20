import 'package:flutter/material.dart';

class MahasiswaPage extends StatefulWidget {
  final String? nrp;

  MahasiswaPage({this.nrp}); // Konstruktor dengan parameter opsional

  @override
  _MahasiswaPageState createState() => _MahasiswaPageState();
}

class _MahasiswaPageState extends State<MahasiswaPage> {
  final List<String> _nrpList = [
    'NRP 0001',
    'NRP 0002',
    'NRP 0003',
    'NRP 0004',
    'NRP 0005',
  ];

  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredNrpList = [];

  @override
  void initState() {
    super.initState();
    _filteredNrpList = _nrpList;
  }

  void _filterNrpList(String query) {
    setState(() {
      _filteredNrpList = _nrpList
          .where((nrp) => nrp.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF42A5F5),
        title: Text(widget.nrp != null
            ? 'Detail NRP: ${widget.nrp}'
            : 'Mahasiswa'),
      ),
      body: widget.nrp != null
          ? Center(
              child: Text(
                'Detail informasi untuk ${widget.nrp}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterNrpList,
                    decoration: InputDecoration(
                      hintText: 'Cari NRP',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredNrpList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MahasiswaPage(
                                    nrp: _filteredNrpList[index]),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              _filteredNrpList[index],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
