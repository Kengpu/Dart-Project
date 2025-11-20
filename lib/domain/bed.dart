import 'patient.dart';

class Bed {
  int id;
  int roomId;
  String bedNumber;
  String status; // Available, Occupied
  Patient? assignedPatient;

  Bed({
    required this.id,
    required this.roomId,
    required this.bedNumber,
    this.status = 'Available',
    this.assignedPatient,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'roomId': roomId,
        'bedNumber': bedNumber,
        'status': status,
        'assignedPatientId': assignedPatient?.id,
      };

  factory Bed.fromJson(Map<String, dynamic> json) => Bed(
        id: json['id'],
        roomId: json['roomId'],
        bedNumber: json['bedNumber'],
        status: json['status'] ?? 'Available',
        assignedPatient: null, // link later in HospitalService
      );

  bool isAvailable() => status == 'Available';

  void release() {
    assignedPatient = null;
    status = 'Available';
  }
}
