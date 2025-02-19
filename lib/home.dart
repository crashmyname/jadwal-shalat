import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _hijriDate = "Loading...";
  String _closestPrayerTime = "Loading...";
  String _currentTime = "";
  String _currentDate = "";
  List<String> prayerTimes = [];

  @override
  void initState() {
    super.initState();
    _fetchHijriDate();
    _fetchPrayerTimes();
    _fetchCurrentDateTime();
  }

  // Fetch Hijri Date from API
  Future<void> _fetchHijriDate() async {
    var url = Uri.parse("https://api.myquran.com/v2/cal/hijr/2024-06-23");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        _hijriDate = data['data']['date'][1] ?? "Tanggal tidak tersedia";
      });
    }
  }

  // Dummy function to simulate fetching prayer times
  Future<void> _fetchPrayerTimes() async {
    prayerTimes = ["05:00", "12:00", "15:30", "18:00", "19:30"];
    _calculateClosestPrayerTime();
  }

  // Calculate the closest prayer time
  void _calculateClosestPrayerTime() {
    DateTime now = DateTime.now();
    String closestTime = "";
    Duration shortestDuration = Duration(hours: 24);

    for (String prayerTime in prayerTimes) {
      DateTime prayerDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(prayerTime.split(":")[0]),
        int.parse(prayerTime.split(":")[1]),
      );

      Duration difference = prayerDateTime.difference(now);
      if (difference.isNegative) continue; // Skip past times
      if (difference < shortestDuration) {
        shortestDuration = difference;
        closestTime = prayerTime;
      }
    }

    setState(() {
      _closestPrayerTime = closestTime.isEmpty ? "Tidak ada waktu dekat" : closestTime;
    });
  }

  // Fetch current date and time
  void _fetchCurrentDateTime() {
    DateTime now = DateTime.now();
    _currentTime = DateFormat('HH:mm:ss').format(now);
    _currentDate = DateFormat('EEEE, d MMMM yyyy').format(now);

    // Update time every second
    Future.delayed(const Duration(seconds: 1), _fetchCurrentDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("Halaman Home"),
        // backgroundColor: Colors.blue,
      ),
      body: Padding(
  padding: const EdgeInsets.all(16.0),
  child: Center(
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 10,
      child: ClipRRect( // Tambahkan ClipRRect agar sudut gambar mengikuti Card
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background Masjid
            SizedBox.expand( // Pastikan gambar menyesuaikan ukuran Card
              child: Image.asset(
                "assets/masjid.jpg",
                fit: BoxFit.cover, // Agar gambar menutupi seluruh area
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tanggal Hijriyah:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    _hijriDate,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Waktu Shalat Terdekat:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    _closestPrayerTime,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  // Tambahkan Jam dan Tanggal
                  const Text(
                    "Tanggal dan Waktu Sekarang:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    "${DateTime.now().toLocal()}",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
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
