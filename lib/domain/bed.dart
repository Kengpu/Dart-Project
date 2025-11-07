import '../data/csv_database.dart';

class Bed {
  static const headers = ['bed_id', 'room_id', 'bed_number', 'bed_type', 'status'];
  static String filePath = 'hospital_data/beds.csv'; // <-- change const to String

  int? bedId;
  int roomId;
  String bedNumber;
  String bedType; // Standard, ICU, Bariatric, Pediatric, Maternity
  String status; // Available, Occupied, Reserved, Maintenance, Out of Service

  Bed({
    this.bedId,
    required this.roomId,
    required this.bedNumber,
    this.bedType = 'Standard',
    this.status = 'Available',
  });

  Future<int> save() async {
    bedId ??= await CSVDatabase.getNextId(filePath, 'bed_id');
    final data = {
      'bed_id': bedId,
      'room_id': roomId,
      'bed_number': bedNumber,
      'bed_type': bedType,
      'status': status,
    };
    await CSVDatabase.appendCsv(filePath, headers, data);
    return bedId!;
  }

  static Future<List<Map<String, dynamic>>> getAll() => CSVDatabase.readCsv(filePath);

  static Future<List<Map<String, dynamic>>> getAvailableBeds({int? roomId}) async {
    final beds = await getAll();
    var available = beds.where((b) => b['status'] == 'Available').toList();
    if (roomId != null) {
      available = available.where((b) => int.parse(b['room_id'].toString()) == roomId).toList();
    }
    return available;
  }

  static Future<void> updateStatus(int bedId, String status) async {
    final beds = await getAll();
    for (var bed in beds) {
      if (int.parse(bed['bed_id'].toString()) == bedId) {
        bed['status'] = status;
      }
    }
    await CSVDatabase.writeCsv(filePath, headers, beds);
  }
}

