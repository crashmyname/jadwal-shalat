import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class JadwalShalatPage extends StatefulWidget {
  const JadwalShalatPage({super.key});

  @override
  _JadwalShalatPageState createState() => _JadwalShalatPageState();
}

class _JadwalShalatPageState extends State<JadwalShalatPage> {
  String _cityId = "";
  String _city = "";
  String _jadwalSubuh = "";
  String _jadwalDzuhur = "";
  String _jadwalAshar = "";
  String _jadwalMagrib = "";
  String _jadwalIsya = "";
  String _jadwalImsak = "";
  String _jadwalTerbit = "";
  String _jadwalDhuha = "";

  @override
  void initState() {
    super.initState();
    _loadCityIdAndFetchJadwal();
  }

  void _loadCityIdAndFetchJadwal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cityId = prefs.getString('cityId') ?? "";

    if (mounted) {
      setState(() {
        _cityId = cityId;
      });
    }

    if (cityId.isNotEmpty) {
      DateTime now = DateTime.now();
      String date = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      var url = Uri.parse("https://api.myquran.com/v2/sholat/jadwal/$cityId/$date");

      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _jadwalSubuh = data['data']['jadwal']['subuh'] ?? "Data tidak tersedia";
            _jadwalDzuhur = data['data']['jadwal']['dzuhur'] ?? "Data tidak tersedia";
            _jadwalAshar = data['data']['jadwal']['ashar'] ?? "Data tidak tersedia";
            _jadwalMagrib = data['data']['jadwal']['maghrib'] ?? "Data tidak tersedia";
            _jadwalIsya = data['data']['jadwal']['isya'] ?? "Data tidak tersedia";
            _jadwalImsak = data['data']['jadwal']['imsak'] ?? "Data tidak tersedia";
            _jadwalTerbit = data['data']['jadwal']['terbit'] ?? "Data tidak tersedia";
            _jadwalDhuha = data['data']['jadwal']['dhuha'] ?? "Data tidak tersedia";
            _city = data['data']['lokasi'] ?? "Data tidak tersedia";
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jadwal Shalat"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _cityId.isEmpty
            ? const Center(child: Text("Silakan atur ID kota di halaman Settings"))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tampilkan lokasi kota
                  Text(
                    "Lokasi: $_city",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  
                  _buildJadwalCard('Imsak', _jadwalImsak),
                  _buildJadwalCard('Subuh', _jadwalSubuh),
                  _buildJadwalCard('Terbit', _jadwalTerbit),
                  _buildJadwalCard('Dhuha', _jadwalDhuha),
                  _buildJadwalCard('Dzuhur', _jadwalDzuhur),
                  _buildJadwalCard('Ashar', _jadwalAshar),
                  _buildJadwalCard('Maghrib', _jadwalMagrib),
                  _buildJadwalCard('Isya', _jadwalIsya),
                ],
              ),
      ),
    );
  }

  Widget _buildJadwalCard(String title, String time) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              time,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
