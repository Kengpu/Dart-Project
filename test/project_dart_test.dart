import 'dart:io';
import 'package:test/test.dart';
import 'package:project_dart/domain/ward.dart';
import 'package:project_dart/domain/room.dart';
import 'package:project_dart/domain/bed.dart';
import 'package:project_dart/domain/patient.dart';
import 'package:project_dart/domain/staff.dart';
import 'package:project_dart/domain/room_assignment.dart';

void main() {
  // Use your CSV folder
  const dataFolder = '../hospital_data';

  setUp(() async {
    // Ensure folder exists
    final dir = Directory(dataFolder);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    // Override file paths for testing
    Ward.filePath = '$dataFolder/wards.csv';
    Room.filePath = '$dataFolder/rooms.csv';
    Bed.filePath = '$dataFolder/beds.csv';
    Patient.filePath = '$dataFolder/patients.csv';
    Staff.filePath = '$dataFolder/staff.csv';
    RoomAssignment.filePath = '$dataFolder/room_assignments.csv';
  });

  tearDown(() async {
    // Clean up CSVs after each test
    final files = [
      Ward.filePath,
      Room.filePath,
      Bed.filePath,
      Patient.filePath,
      Staff.filePath,
      RoomAssignment.filePath,
    ];

    for (var f in files) {
      final file = File(f);
      if (await file.exists()) {
        await file.delete();
      }
    }
  });

  test('Ward CRUD operations', () async {
    final ward = Ward(
      name: 'Cardiology',
      floor: 1,
      department: 'Heart',
      totalCapacity: 10,
    );

    final id = await ward.save();
    expect(id, 1);

    final wards = await Ward.getAll();
    expect(wards.length, 1);
    expect(wards.first['name'], 'Cardiology');
  });

  test('Room CRUD operations', () async {
    final room = Room(
      wardId: 1,
      roomNumber: '101A',
      type: 'ICU',
      capacity: 2,
    );

    final id = await room.save();
    expect(id, 1);

    final rooms = await Room.getAll();
    expect(rooms.length, 1);
    expect(rooms.first['room_number'], '101A');
  });

  test('Bed CRUD operations', () async {
    final bed = Bed(
      roomId: 1,
      bedNumber: 'B1',
      bedType: 'ICU',
    );

    final id = await bed.save();
    expect(id, 1);

    final beds = await Bed.getAll();
    expect(beds.length, 1);
    expect(beds.first['bed_number'], 'B1');
  });

  test('Patient CRUD operations', () async {
    final patient = Patient(
      medicalRecordNumber: 'MRN001',
      fullName: 'John Doe',
      dob: '1990-01-01',
      gender: 'Male',
    );

    final id = await patient.save();
    expect(id, 1);

    final patients = await Patient.getAll();
    expect(patients.length, 1);
    expect(patients.first['full_name'], 'John Doe');
  });

  test('Staff CRUD operations', () async {
    final staff = Staff(
      employeeNumber: 'EMP001',
      fullName: 'Alice Smith',
      role: 'Nurse',
      department: 'Cardiology',
    );

    final id = await staff.save();
    expect(id, 1);

    final staffList = await Staff.getAll();
    expect(staffList.length, 1);
    expect(staffList.first['full_name'], 'Alice Smith');
  });

  test('RoomAssignment CRUD operations', () async {
    final assignment = RoomAssignment(
      bedId: 1,
      patientId: 1,
      assignedBy: 1,
    );

    final id = await assignment.save();
    expect(id, 1);

    final assignments = await RoomAssignment.getActiveAssignments();
    expect(assignments.length, 1);
    expect(assignments.first['bed_id'], '1');
  });
}
