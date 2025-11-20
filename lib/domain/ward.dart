// lib/domain/ward.dart
import 'room.dart';

class Ward {
  int id;
  String name;
  List<Room> rooms = [];

  Ward({required this.id, required this.name, List<Room>? rooms}) {
    if (rooms != null) this.rooms = rooms;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  factory Ward.fromJson(Map<String, dynamic> json) => Ward(
        id: json['id'],
        name: json['name'],
      );

  // --- LOGIC ---
  void addRoom(Room room) => rooms.add(room);

  void removeRoom(Room room) => rooms.removeWhere((r) => r.id == room.id);

  List<Room> availableRooms() => rooms.where((r) => r.status == 'Available').toList();
}
