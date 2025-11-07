import '../data/csv_database.dart';

class Ward {
  static const headers = ['ward_id', 'name', 'floor', 'department', 'total_capacity'];

  // Change from const to static so tests can override it
  static String filePath = 'hospital_data/wards.csv';

  int? wardId;
  String name;
  int floor;
  String department;
  int totalCapacity;

  Ward({
    this.wardId,
    required this.name,
    required this.floor,
    required this.department,
    required this.totalCapacity,
  });

  Future<int> save() async {
    wardId ??= await CSVDatabase.getNextId(filePath, 'ward_id');
    final data = {
      'ward_id': wardId,
      'name': name,
      'floor': floor,
      'department': department,
      'total_capacity': totalCapacity,
    };
    await CSVDatabase.appendCsv(filePath, headers, data);
    return wardId!;
  }

  static Future<List<Map<String, dynamic>>> getAll() => CSVDatabase.readCsv(filePath);

  static Future<Map<String, dynamic>?> getById(int id) async {
    final wards = await getAll();
    try {
      return wards.firstWhere((w) => int.parse(w['ward_id'].toString()) == id);
    } catch (_) {
      return null;
    }
  }
}
