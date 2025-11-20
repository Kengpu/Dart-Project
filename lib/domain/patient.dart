import 'bed.dart';

class Patient {
  int id;
  String name;
  String dob;
  Bed? assignedBed;

  Patient({required this.id, required this.name, required this.dob, this.assignedBed});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'dob': dob,
        'assignedBedId': assignedBed?.id,
      };

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        id: json['id'],
        name: json['name'],
        dob: json['dob'],
        assignedBed: null, // reset; link later in HospitalService
      );

  void assignBed(Bed bed) {
    if (!bed.isAvailable()) {
      throw Exception('Bed ${bed.bedNumber} is not available');
    }

    // Release current bed if exists
    if (assignedBed != null) {
      assignedBed!.release();
    }

    assignedBed = bed;
    bed.assignedPatient = this;
    bed.status = 'Occupied';
  }

  void releaseBed() {
    if (assignedBed != null) {
      assignedBed!.release();
      assignedBed = null;
    }
  }

  bool hasBed() => assignedBed != null;
}
