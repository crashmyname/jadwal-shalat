import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const BottomNavigationBarExampleApp());

class BottomNavigationBarExampleApp extends StatelessWidget {
  const BottomNavigationBarExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: BottomNavigationBarExample());
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() => _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const JadwalShalatPage(),
    const SuratAlquranPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aplikasi Islamic Monitor')),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Jadwal Shalat'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Surat Al-Qur\'an'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Halaman Home
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Home',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

// Halaman Jadwal Shalat
class JadwalShalatPage extends StatelessWidget {
  const JadwalShalatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Jadwal Shalat',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

// Halaman Surat Al-Qur'an
class SuratAlquranPage extends StatelessWidget {
  const SuratAlquranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Halaman Surat Al-Qur\'an',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

// Halaman Settings dengan pengaturan dan pengiriman otomatis ke API
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings(); // Muat pengaturan saat halaman dimulai
  }

  // Fungsi untuk memuat pengaturan dari SharedPreferences
  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notifEnabled = prefs.getBool('notifEnabled') ?? false;
    });
  }

  // Fungsi untuk menyimpan pengaturan dan mengirim ke API
  void _saveSettings(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notifEnabled', value);
    _sendSettingsToAPI(value);
  }

  // Fungsi untuk mengirim pengaturan ke API
  void _sendSettingsToAPI(bool value) async {
    var url = Uri.parse('https://example.com/api/update-settings'); // Ganti dengan URL API Anda
    var response = await http.post(
      url,
      body: json.encode({'notifEnabled': value}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengaturan berhasil diperbarui')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui pengaturan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SwitchListTile(
        title: const Text('Aktifkan Notifikasi'),
        value: _notifEnabled,
        onChanged: (value) {
          setState(() {
            _notifEnabled = value;
          });
          _saveSettings(value); // Simpan pengaturan dan kirim ke API
        },
      ),
    );
  }
}
