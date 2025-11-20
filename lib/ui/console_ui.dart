// lib/ui/console_ui.dart
import 'dart:io';
import '../service/hospital_service.dart';
import '../domain/patient.dart';
import '../domain/bed.dart';
import '../domain/room.dart';
import '../domain/ward.dart';

class ConsoleUI {
  final HospitalService service;

  ConsoleUI(this.service);

  Future<void> start() async {
    while (true) {
      print('\n=== Hospital Management System ===');
      print('1. List Wards');
      print('2. List Rooms');
      print('3. List Beds');
      print('4. List Patients');
      print('5. Add Ward');
      print('6. Add Room');
      print('7. Add Bed');
      print('8. Add Patient');
      print('9. Assign Bed to Patient');
      print('10. Release Bed');
      print('0. Exit');

      stdout.write('Choose an option: ');
      final choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          listWards();
          break;
        case '2':
          listRooms();
          break;
        case '3':
          listBeds();
          break;
        case '4':
          listPatients();
          break;
        case '5':
          await addWard();
          break;
        case '6':
          await addRoom();
          break;
        case '7':
          await addBed();
          break;
        case '8':
          await addPatient();
          break;
        case '9':
          await assignBed();
          break;
        case '10':
          await releaseBed();
          break;
        case '0':
          print('Exiting...');
          exit(0);
        default:
          print('Invalid option!');
      }
    }
  }

  void listWards() {
    final wards = service.getWards();
    if (wards.isEmpty) {
      print('No wards found.');
      return;
    }
    print('\n--- Wards ---');
    for (var w in wards) {
      print('ID: ${w.id}, Name: ${w.name}');
    }
  }

  void listRooms() {
    final rooms = service.getRooms();
    if (rooms.isEmpty) {
      print('No rooms found.');
      return;
    }
    print('\n--- Rooms ---');
    for (var r in rooms) {
      print('ID: ${r.id}, Ward ID: ${r.wardId}, Type: ${r.type}, Status: ${r.status}');
    }
  }

  void listBeds() {
    final beds = service.getBeds();
    if (beds.isEmpty) {
      print('No beds found.');
      return;
    }
    print('\n--- Beds ---');
    for (var b in beds) {
      final patientName = b.assignedPatient?.name ?? 'None';
      print('ID: ${b.id}, Bed: ${b.bedNumber}, Room ID: ${b.roomId}, Status: ${b.status}, Patient: $patientName');
    }
  }

  void listPatients() {
    final patients = service.getPatients();
    if (patients.isEmpty) {
      print('No patients found.');
      return;
    }
    print('\n--- Patients ---');
    for (var p in patients) {
      final bedNumber = p.assignedBed?.bedNumber ?? 'None';
      print('ID: ${p.id}, Name: ${p.name}, DOB: ${p.dob}, Assigned Bed: $bedNumber');
    }
  }

  Future<void> addWard() async {
    stdout.write('Enter Ward ID: ');
    final id = int.parse(stdin.readLineSync()!);
    stdout.write('Enter Ward Name: ');
    final name = stdin.readLineSync()!;
    final ward = Ward(id: id, name: name);
    service.addWard(ward);
    await service.save();
    print('Ward added successfully.');
  }

  Future<void> addRoom() async {
    stdout.write('Enter Room ID: ');
    final id = int.parse(stdin.readLineSync()!);
    stdout.write('Enter Ward ID: ');
    final wardId = int.parse(stdin.readLineSync()!);
    stdout.write('Enter Room Type: ');
    final type = stdin.readLineSync()!;
    final room = Room(id: id, wardId: wardId, type: type);
    service.addRoom(room);
    await service.save();
    print('Room added successfully.');
  }

  Future<void> addBed() async {
    stdout.write('Enter Bed ID: ');
    final id = int.parse(stdin.readLineSync()!);
    stdout.write('Enter Room ID: ');
    final roomId = int.parse(stdin.readLineSync()!);
    stdout.write('Enter Bed Number: ');
    final bedNumber = stdin.readLineSync()!;
    final bed = Bed(id: id, roomId: roomId, bedNumber: bedNumber);
    service.addBed(bed);
    await service.save();
    print('Bed added successfully.');
  }

  Future<void> addPatient() async {
    stdout.write('Enter Patient ID: ');
    final id = int.parse(stdin.readLineSync()!);
    stdout.write('Enter Name: ');
    final name = stdin.readLineSync()!;
    stdout.write('Enter DOB (YYYY-MM-DD): ');
    final dob = stdin.readLineSync()!;
    final patient = Patient(id: id, name: name, dob: dob);
    service.addPatient(patient);
    await service.save();
    print('Patient added successfully.');
  }

  Future<void> assignBed() async {
    final beds = service.getAvailableBeds();
    if (beds.isEmpty) {
      print('No available beds.');
      return;
    }
    listPatients();
    stdout.write('Enter Patient ID: ');
    final patientId = int.parse(stdin.readLineSync()!);
    print('\nAvailable Beds:');
    for (var b in beds) {
      print('ID: ${b.id}, Bed: ${b.bedNumber}, Room ID: ${b.roomId}');
    }
    stdout.write('Enter Bed ID to assign: ');
    final bedId = int.parse(stdin.readLineSync()!);
    service.assignBedToPatient(bedId, patientId);
    await service.save();
    print('Bed assigned successfully.');
  }

  Future<void> releaseBed() async {
    final beds = service.getBeds().where((b) => !b.isAvailable()).toList();
    if (beds.isEmpty) {
      print('No occupied beds.');
      return;
    }
    print('\nOccupied Beds:');
    for (var b in beds) {
      print('ID: ${b.id}, Bed: ${b.bedNumber}, Patient: ${b.assignedPatient?.name}');
    }
    stdout.write('Enter Bed ID to release: ');
    final bedId = int.parse(stdin.readLineSync()!);
    service.releaseBed(bedId);
    await service.save();
    print('Bed released successfully.');
  }
}
