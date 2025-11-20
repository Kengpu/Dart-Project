import 'package:test/test.dart';
import 'package:project_dart/service/hospital_service.dart';
import 'package:project_dart/domain/ward.dart';
import 'package:project_dart/domain/room.dart';
import 'package:project_dart/domain/bed.dart';
import 'package:project_dart/domain/patient.dart';
import 'package:project_dart/data/json_database.dart';

void main() {
  group('HospitalService Tests', () {
    late HospitalService service;

    setUp(() async {
      // Use an in-memory database
      final db = JsonDatabase('test_data.json');
      await db.load();
      service = HospitalService(db);

      // Initialize empty data
      db.set('wards', []);
      db.set('rooms', []);
      db.set('beds', []);
      db.set('patients', []);
    });

    test('Add Ward', () async {
      final ward = Ward(id: 1, name: 'General');
      service.addWard(ward);
      expect(service.getWards().length, equals(1));
      expect(service.getWards().first.name, equals('General'));
    });

    test('Add Room under Ward', () async {
      final ward = Ward(id: 1, name: 'General');
      service.addWard(ward);
      final room = Room(id: 1, wardId: 1, type: 'ICU');
      service.addRoom(room);

      final rooms = service.getRooms();
      expect(rooms.length, equals(1));
      expect(rooms.first.type, equals('ICU'));
    });

    test('Add Bed under Room', () async {
      final ward = Ward(id: 1, name: 'General');
      service.addWard(ward);
      final room = Room(id: 1, wardId: 1, type: 'ICU');
      service.addRoom(room);

      final bed = Bed(id: 1, roomId: 1, bedNumber: 'B-101');
      service.addBed(bed);

      final beds = service.getBeds();
      expect(beds.length, equals(1));
      expect(beds.first.bedNumber, equals('B-101'));
    });

    test('Add Patient', () async {
      final patient = Patient(id: 1, name: 'John Doe', dob: '1990-01-01');
      service.addPatient(patient);

      final patients = service.getPatients();
      expect(patients.length, equals(1));
      expect(patients.first.name, equals('John Doe'));
    });

    test('Assign Bed to Patient', () async {
      final ward = Ward(id: 1, name: 'General');
      service.addWard(ward);
      final room = Room(id: 1, wardId: 1, type: 'General');
      service.addRoom(room);
      final bed = Bed(id: 1, roomId: 1, bedNumber: 'B-101');
      service.addBed(bed);
      final patient = Patient(id: 1, name: 'John Doe', dob: '1990-01-01');
      service.addPatient(patient);

      service.assignBedToPatient(1, 1);

      final updatedBed = service.getBeds().first;
      final updatedPatient = service.getPatients().first;

      expect(updatedBed.status, equals('Occupied'));
      expect(updatedPatient.assignedBed?.bedNumber, equals('B-101'));
    });

    test('Release Bed from Patient', () async {
      final ward = Ward(id: 1, name: 'General');
      service.addWard(ward);
      final room = Room(id: 1, wardId: 1, type: 'General');
      service.addRoom(room);
      final bed = Bed(id: 1, roomId: 1, bedNumber: 'B-101', status: 'Occupied');
      final patient = Patient(id: 1, name: 'John Doe', dob: '1990-01-01');
      bed.assignedPatient = patient;
      patient.assignedBed = bed;
      service.addBed(bed);
      service.addPatient(patient);

      service.releaseBed(1);

      final releasedBed = service.getBeds().first;
      expect(releasedBed.status, equals('Available'));
      expect(releasedBed.assignedPatient, isNull);
    });

    test('Room status updates correctly', () async {
      final ward = Ward(id: 1, name: 'General');
      service.addWard(ward);
      final room = Room(id: 1, wardId: 1, type: 'General');
      service.addRoom(room);
      final bed1 = Bed(id: 1, roomId: 1, bedNumber: 'A');
      final bed2 = Bed(id: 2, roomId: 1, bedNumber: 'B');
      service.addBed(bed1);
      service.addBed(bed2);

      // Assign one bed
      final patient = Patient(id: 1, name: 'Jane', dob: '1992-05-10');
      service.addPatient(patient);
      service.assignBedToPatient(1, 1);

      final updatedRoom = service.getRooms().first;
      expect(updatedRoom.status, equals('Partially Occupied'));

      // Assign both
      final patient2 = Patient(id: 2, name: 'Sam', dob: '1989-03-03');
      service.addPatient(patient2);
      service.assignBedToPatient(2, 2);

      final fullRoom = service.getRooms().first;
      expect(fullRoom.status, equals('Occupied'));
    });
  });
}
