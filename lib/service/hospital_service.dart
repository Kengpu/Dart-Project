// lib/service/hospital_service.dart
import '../data/json_database.dart';
import '../domain/patient.dart';
import '../domain/ward.dart';
import '../domain/room.dart';
import '../domain/bed.dart';

class HospitalService {
  final JsonDatabase db;

  HospitalService(this.db);

  Future<void> load() async => await db.load();
  Future<void> save() async => await db.save();

  List<Ward> getWards() => db.get('wards').map((w) => Ward.fromJson(w)).toList();
  List<Room> getRooms() => db.get('rooms').map((r) => Room.fromJson(r)).toList();
  List<Bed> getBeds() => db.get('beds').map((b) => Bed.fromJson(b)).toList();
  List<Patient> getPatients() => db.get('patients').map((p) => Patient.fromJson(p)).toList();

  void addPatient(Patient patient) {
    final patients = getPatients();
    patients.add(patient);
    db.set('patients', patients.map((p) => p.toJson()).toList());
  }

  void addBed(Bed bed) {
    final beds = getBeds();
    beds.add(bed);
    db.set('beds', beds.map((b) => b.toJson()).toList());
  }

  void addRoom(Room room) {
    final rooms = getRooms();
    rooms.add(room);
    db.set('rooms', rooms.map((r) => r.toJson()).toList());
  }

  void addWard(Ward ward) {
    final wards = getWards();
    wards.add(ward);
    db.set('wards', wards.map((w) => w.toJson()).toList());
  }

  List<Bed> getAvailableBeds() {
    final beds = getBeds();
    final rooms = getRooms();
    return beds.where((b) {
      final roomExists = rooms.any((r) => r.id == b.roomId);
      return b.isAvailable() && roomExists;
    }).toList();
  }

  void assignBedToPatient(int bedId, int patientId) {
    final beds = getBeds();
    final patients = getPatients();
    final rooms = getRooms();

    final bed = beds.firstWhere(
      (b) => b.id == bedId,
      orElse: () => throw Exception('Bed $bedId not found'),
    );

    final patient = patients.firstWhere(
      (p) => p.id == patientId,
      orElse: () => throw Exception('Patient $patientId not found'),
    );

    final room = rooms.firstWhere(
      (r) => r.id == bed.roomId,
      orElse: () => throw Exception('Room ${bed.roomId} not found for Bed ${bed.bedNumber}'),
    );

    // Assign bed safely
    patient.assignBed(bed);
    room.updateStatus();

    // Save updates
    db.set('beds', beds.map((b) => b.toJson()).toList());
    db.set('patients', patients.map((p) => p.toJson()).toList());
    db.set('rooms', rooms.map((r) => r.toJson()).toList());
  }

  void releaseBed(int bedId) {
    final beds = getBeds();
    final patients = getPatients();
    final rooms = getRooms();

    final bed = beds.firstWhere(
      (b) => b.id == bedId,
      orElse: () => throw Exception('Bed $bedId not found'),
    );

    if (bed.assignedPatient != null) {
      bed.assignedPatient!.releaseBed();
    }

    final room = rooms.firstWhere(
      (r) => r.id == bed.roomId,
      orElse: () => throw Exception('Room ${bed.roomId} not found for Bed ${bed.bedNumber}'),
    );

    room.updateStatus();

    db.set('beds', beds.map((b) => b.toJson()).toList());
    db.set('patients', patients.map((p) => p.toJson()).toList());
    db.set('rooms', rooms.map((r) => r.toJson()).toList());
  }
}
