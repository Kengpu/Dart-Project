import 'dart:io';

class CSVDatabase {
  static Future<void> writeCsv(
      String filepath, List<String> headers, List<Map<String, dynamic>> data) async {
    final file = File(filepath);

    // Ensure folder exists
    await _ensureFolderExists(file);

    final buffer = StringBuffer();
    buffer.writeln(headers.join(','));

    for (var row in data) {
      final values = headers.map((header) => _escapeCsvValue(row[header]?.toString() ?? '')).toList();
      buffer.writeln(values.join(','));
    }

    await file.writeAsString(buffer.toString());
  }

  static Future<List<Map<String, dynamic>>> readCsv(String filepath) async {
    final file = File(filepath);
    if (!await file.exists()) return [];

    final lines = await file.readAsLines();
    if (lines.isEmpty) return [];

    final headers = _parseCsvLine(lines[0]);
    final data = <Map<String, dynamic>>[];

    for (var i = 1; i < lines.length; i++) {
      final values = _parseCsvLine(lines[i]);
      final row = <String, dynamic>{};
      for (var j = 0; j < headers.length && j < values.length; j++) {
        row[headers[j]] = values[j];
      }
      data.add(row);
    }

    return data;
  }

  static Future<void> appendCsv(String filepath, List<String> headers, Map<String, dynamic> data) async {
    final file = File(filepath);

    // Ensure folder exists
    await _ensureFolderExists(file);

    final exists = await file.exists();
    final buffer = StringBuffer();

    if (!exists) buffer.writeln(headers.join(','));

    final values = headers.map((header) => _escapeCsvValue(data[header]?.toString() ?? '')).toList();
    buffer.writeln(values.join(','));

    await file.writeAsString(buffer.toString(), mode: FileMode.append);
  }

  static Future<int> getNextId(String filepath, String idField) async {
    final data = await readCsv(filepath);
    if (data.isEmpty) return 1;

    int maxId = 0;
    for (var row in data) {
      final id = int.tryParse(row[idField]?.toString() ?? '0') ?? 0;
      if (id > maxId) maxId = id;
    }
    return maxId + 1;
  }

  static String _escapeCsvValue(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  static List<String> _parseCsvLine(String line) {
    final result = <String>[];
    final buffer = StringBuffer();
    bool inQuotes = false;

    for (var i = 0; i < line.length; i++) {
      final char = line[i];
      if (char == '"') {
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          buffer.write('"');
          i++;
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        result.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }

    result.add(buffer.toString());
    return result;
  }

  // ------------------- Helper -------------------
  static Future<void> _ensureFolderExists(File file) async {
    final dir = file.parent;
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }
}
