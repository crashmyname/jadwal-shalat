import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _cityIdController = TextEditingController();
  String _savedCityId = "";

  @override
  void initState() {
    super.initState();
    _loadSavedCityId();
  }

  void _loadSavedCityId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedCityId = prefs.getString('cityId') ?? "";
      _cityIdController.text = _savedCityId;
    });
  }

  void _saveCityId(String cityId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cityId', cityId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ID Kota berhasil disimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _cityIdController,
            decoration: const InputDecoration(
              labelText: 'Masukkan ID Kota',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _saveCityId(_cityIdController.text);
            },
            child: const Text('Simpan ID Kota'),
          ),
        ],
      ),
    );
  }
}
