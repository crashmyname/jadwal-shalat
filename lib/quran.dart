import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SuratAlquranPage extends StatefulWidget {
  const SuratAlquranPage({super.key});

  @override
  _SuratAlquranPageState createState() => _SuratAlquranPageState();
}

class _SuratAlquranPageState extends State<SuratAlquranPage> {
  // Future untuk mengambil data surat dari API
  Future<List<dynamic>> _fetchSuratData() async {
    final response =
        await http.get(Uri.parse('https://api.myquran.com/v2/quran/surat/semua'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['data'];
    } else {
      throw Exception('Failed to load Surat data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Surat Al-Qur\'an'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchSuratData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data surat'));
          }

          final suratList = snapshot.data!;
          return ListView.builder(
            itemCount: suratList.length,
            itemBuilder: (context, index) {
              final surat = suratList[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${surat['number']}. ${surat['name_id']} (${surat['translation_id']})',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Jumlah Ayat: ${surat['number_of_verses']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tipe Wahyu: ${surat['revelation_id']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          // Contoh: memutar audio saat tombol ditekan
                          print('Audio URL: ${surat['audio_url']}');
                        },
                        child: const Text('Putar Audio'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
