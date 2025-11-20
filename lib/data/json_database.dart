// lib/data/json_database.dart
import 'dart:convert';
import 'dart:io';

class JsonDatabase {
  final String filePath;
  Map<String, dynamic> _data = {};

  JsonDatabase(this.filePath);

  Future<void> load() async {
    final file = File(filePath);
    final directory = file.parent;

    // Create folder if it doesn't exist
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    // Create file with default structure if it doesn't exist
    if (!await file.exists()) {
      _data = {
        "wards": [],
        "rooms": [],
        "beds": [],
        "patients": []
      };
      await save();
    } else {
      final content = await file.readAsString();
      _data = jsonDecode(content);
    }
  }

  Future<void> save() async {
    final file = File(filePath);
    await file.writeAsString(jsonEncode(_data), flush: true);
  }

  List<Map<String, dynamic>> get(String key) => List<Map<String, dynamic>>.from(_data[key]);

  void set(String key, List<Map<String, dynamic>> value) => _data[key] = value;
}
