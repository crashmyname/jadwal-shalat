import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _cityIdController = TextEditingController();
  String _savedCityId = "";
  List<dynamic> _searchResults = [];
  late Future<void> _loadSavedCityIdFuture;

  @override
  void initState() {
    super.initState();
    _loadSavedCityIdFuture = _loadSavedCityId(); // Memuat ID kota yang tersimpan saat awal
  }

  // Fungsi untuk memuat ID kota yang disimpan
  Future<void> _loadSavedCityId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedCityId = prefs.getString('cityId') ?? "";
      _cityIdController.text = _savedCityId; // Memuat ID kota yang disimpan
    });
  }

  // Fungsi untuk menyimpan ID kota ke SharedPreferences
  void _saveCityId(String cityId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cityId', cityId); // Simpan ID kota
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ID Kota berhasil disimpan')),
    );
  }

  // Fungsi untuk mencari ID kota berdasarkan keyword
  void _searchCity(String keyword) async {
    if (keyword.isNotEmpty) {
      var url = Uri.parse("https://api.myquran.com/v2/sholat/kota/cari/$keyword");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _searchResults = data['data'] ?? [];
        });
      } else {
        setState(() {
          _searchResults = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mencari kota')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadSavedCityIdFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Input untuk mencari kota
              TextField(
                controller: _cityIdController,
                decoration: const InputDecoration(
                  labelText: 'Masukkan Nama Kota',
                  border: OutlineInputBorder(),
                ),
                onChanged: _searchCity, // Pencarian akan terjadi saat text berubah
              ),
              const SizedBox(height: 16),

              // Menampilkan hasil pencarian kota
              if (_searchResults.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      var city = _searchResults[index];
                      return ListTile(
                        title: Text(city['lokasi']),
                        subtitle: Text(city['lokasi']),
                        onTap: () {
                          // Menyimpan ID kota, bukan nama kota
                          _saveCityId(city['id'].toString());
                          _cityIdController.text = city['lokasi']; // Menampilkan nama kota
                          setState(() {
                            _searchResults = [];
                          });
                        },
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),

              // Tombol untuk menyimpan ID kota yang telah dipilih
              ElevatedButton(
                onPressed: () {
                  _saveCityId(_savedCityId); // Menyimpan ID kota yang sudah dipilih
                },
                child: const Text('Simpan ID Kota'),
              ),
            ],
          ),
        );
      },
    );
  }
}
