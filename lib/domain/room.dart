// lib/domain/room.dart
import 'bed.dart';

class Room {
  int id;
  int wardId;
  String type;
  String status; // Available or Full
  List<Bed> beds = [];

  Room({required this.id, required this.wardId, required this.type, this.status = 'Available', List<Bed>? beds}) {
    if (beds != null) this.beds = beds;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'wardId': wardId,
        'type': type,
        'status': status,
      };

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json['id'],
        wardId: json['wardId'],
        type: json['type'],
      );

  void addBed(Bed bed) {
    beds.add(bed);
    updateStatus();
  }

  void removeBed(Bed bed) {
    beds.removeWhere((b) => b.id == bed.id);
    updateStatus();
  }

  List<Bed> availableBeds() => beds.where((b) => b.isAvailable()).toList();

  void updateStatus() {
    status = beds.any((b) => b.isAvailable()) ? 'Available' : 'Full';
  }
}
