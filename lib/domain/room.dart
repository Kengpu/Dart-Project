import '../data/csv_database.dart';

class Room {
  static const headers = [
    'room_id',
    'ward_id',
    'room_number',
    'type',
    'capacity',
    'has_bathroom',
    'is_isolation_room',
    'status'
  ];

  // Changed from const to static so it can be overridden in tests
  static String filePath = 'hospital_data/rooms.csv';

  int? roomId;
  int wardId;
  String roomNumber;
  String type; // ICU, Private, Semi-Private, Ward, Emergency, Isolation
  int capacity;
  bool hasBathroom;
  bool isIsolationRoom;
  String status; // Available, Occupied, Maintenance, Cleaning, Out of Service

  Room({
    this.roomId,
    required this.wardId,
    required this.roomNumber,
    required this.type,
    required this.capacity,
    this.hasBathroom = true,
    this.isIsolationRoom = false,
    this.status = 'Available',
  });

  Future<int> save() async {
    roomId ??= await CSVDatabase.getNextId(filePath, 'room_id');
    final data = {
      'room_id': roomId,
      'ward_id': wardId,
      'room_number': roomNumber,
      'type': type,
      'capacity': capacity,
      'has_bathroom': hasBathroom,
      'is_isolation_room': isIsolationRoom,
      'status': status,
    };
    await CSVDatabase.appendCsv(filePath, headers, data);
    return roomId!;
  }

  static Future<List<Map<String, dynamic>>> getAll() => CSVDatabase.readCsv(filePath);

  static Future<List<Map<String, dynamic>>> getAvailableRooms({String? roomType}) async {
    final rooms = await getAll();
    var available = rooms.where((r) => r['status'] == 'Available').toList();
    if (roomType != null) {
      available = available.where((r) => r['type'] == roomType).toList();
    }
    return available;
  }
}
