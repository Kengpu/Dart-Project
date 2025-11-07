import 'dart:io';
import '../domain/ward.dart';
import '../domain/room.dart';
import '../domain/bed.dart';
import '../domain/patient.dart';
import '../domain/staff.dart';
import '../domain/room_assignment.dart';

class ConsoleUI {
  void printHeader(String title) {
    print('\n=== $title ===');
  }

  Future<void> start() async {
    while (true) {
      printHeader('Hospital Management System');
      print('1. Manage');
      print('2. View');
      print('0. Exit');
      stdout.write('Select an option: ');
      final choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          await manageMenu();
          break;
        case '2':
          await viewMenu();
          break;
        case '0':
          print('Goodbye!');
          return;
        default:
          print('Invalid option, try again.');
      }
    }
  }

  // =================== Manage Menu ===================
  Future<void> manageMenu() async {
    printHeader('Manage Menu');
    print('1. Wards');
    print('2. Rooms');
    print('3. Beds');
    print('4. Patients');
    print('5. Staff');
    print('6. Room Assignments');
    print('0. Back');

    stdout.write('Select an option: ');
    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        await manageWards();
        break;
      case '2':
        await manageRooms();
        break;
      case '3':
        await manageBeds();
        break;
      case '4':
        await managePatients();
        break;
      case '5':
        await manageStaff();
        break;
      case '6':
        await manageAssignments();
        break;
      case '0':
        return;
      default:
        print('Invalid option.');
    }
  }

  // =================== View Menu ===================
  Future<void> viewMenu() async {
    printHeader('View Menu');
    print('1. Wards');
    print('2. Rooms');
    print('3. Beds');
    print('4. Patients');
    print('5. Staff');
    print('6. Room Assignments');
    print('0. Back');

    stdout.write('Select an option: ');
    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        await viewWards();
        break;
      case '2':
        await viewRooms();
        break;
      case '3':
        await viewBeds();
        break;
      case '4':
        await viewPatients();
        break;
      case '5':
        await viewStaff();
        break;
      case '6':
        await viewAssignments();
        break;
      case '0':
        return;
      default:
        print('Invalid option.');
    }
  }

  // =================== Manage Methods ===================
  Future<void> manageWards() async {
    printHeader('Create Ward');
    stdout.write('Ward Name: ');
    final name = stdin.readLineSync() ?? '';
    stdout.write('Floor: ');
    final floor = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
    stdout.write('Department: ');
    final dept = stdin.readLineSync() ?? '';
    stdout.write('Total Capacity: ');
    final cap = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

    final ward = Ward(name: name, floor: floor, department: dept, totalCapacity: cap);
    final id = await ward.save();
    print('Ward created with ID: $id');
  }

  Future<void> manageRooms() async {
    printHeader('Create Room');
    final wards = await Ward.getAll();
    if (wards.isEmpty) {
      print('No wards found. Create a ward first.');
      return;
    }

    print('Available Wards:');
    for (var w in wards) {
      print('${w['ward_id']}: ${w['name']}');
    }
    stdout.write('Ward ID: ');
    final wardId = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
    stdout.write('Room Number: ');
    final num = stdin.readLineSync() ?? '';

    final roomTypes = ['ICU','Private','Semi-Private','Ward','Emergency','Isolation'];
    print('Room Type Options: ${roomTypes.join(', ')}');
    stdout.write('Room Type: ');
    final typeInput = stdin.readLineSync() ?? 'Ward';
    final type = roomTypes.contains(typeInput) ? typeInput : 'Ward';

    stdout.write('Capacity: ');
    final cap = int.tryParse(stdin.readLineSync() ?? '') ?? 1;

    final room = Room(wardId: wardId, roomNumber: num, type: type, capacity: cap);
    final id = await room.save();
    print('Room created with ID: $id');
  }

  Future<void> manageBeds() async {
    printHeader('Create Bed');
    final rooms = await Room.getAll();
    if (rooms.isEmpty) {
      print('No rooms found. Create a room first.');
      return;
    }

    print('Available Rooms:');
    for (var r in rooms) {
      print('${r['room_id']}: ${r['room_number']}');
    }
    stdout.write('Room ID: ');
    final roomId = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
    stdout.write('Bed Number: ');
    final num = stdin.readLineSync() ?? '';

    final bedTypes = ['Standard','ICU','Bariatric','Pediatric','Maternity'];
    print('Bed Type Options: ${bedTypes.join(', ')}');
    stdout.write('Bed Type: ');
    final typeInput = stdin.readLineSync() ?? 'Standard';
    final type = bedTypes.contains(typeInput) ? typeInput : 'Standard';

    final bed = Bed(roomId: roomId, bedNumber: num, bedType: type);
    final id = await bed.save();
    print('Bed created with ID: $id');
  }

  Future<void> managePatients() async {
    printHeader('Create Patient');
    stdout.write('Medical Record Number: ');
    final mrn = stdin.readLineSync() ?? '';
    stdout.write('Full Name: ');
    final name = stdin.readLineSync() ?? '';
    stdout.write('Date of Birth (YYYY-MM-DD): ');
    final dob = stdin.readLineSync() ?? '';

    final genders = ['Male','Female','Other'];
    print('Gender Options: ${genders.join(', ')}');
    stdout.write('Gender: ');
    final genderInput = stdin.readLineSync() ?? 'Other';
    final gender = genders.contains(genderInput) ? genderInput : 'Other';

    final patient = Patient(
      medicalRecordNumber: mrn,
      fullName: name,
      dob: dob,
      gender: gender,
    );
    final id = await patient.save();
    print('Patient created with ID: $id');
  }

  Future<void> manageStaff() async {
    printHeader('Create Staff');
    stdout.write('Employee Number: ');
    final empNum = stdin.readLineSync() ?? '';
    stdout.write('Full Name: ');
    final name = stdin.readLineSync() ?? '';

    final roles = ['Doctor','Nurse','Technician','Housekeeper','Admin','Manager'];
    print('Role Options: ${roles.join(', ')}');
    stdout.write('Role: ');
    final roleInput = stdin.readLineSync() ?? 'Admin';
    final role = roles.contains(roleInput) ? roleInput : 'Admin';

    stdout.write('Department: ');
    final dept = stdin.readLineSync() ?? '';

    final staff = Staff(
      employeeNumber: empNum,
      fullName: name,
      role: role,
      department: dept,
    );
    final id = await staff.save();
    print('Staff created with ID: $id');
  }

  Future<void> manageAssignments() async {
    printHeader('Assign Room/Bed');
    final beds = await Bed.getAvailableBeds();
    if (beds.isEmpty) {
      print('No available beds.');
      return;
    }

    final patients = await Patient.getAll();
    if (patients.isEmpty) {
      print('No patients found.');
      return;
    }

    final staffList = await Staff.getAll();
    if (staffList.isEmpty) {
      print('No staff found.');
      return;
    }

    print('Available Beds:');
    for (var b in beds) {
      print('${b['bed_id']}: Room ${b['room_id']} Bed ${b['bed_number']}');
    }
    stdout.write('Bed ID: ');
    final bedId = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

    print('Patients:');
    for (var p in patients) {
      print('${p['patient_id']}: ${p['full_name']}');
    }
    stdout.write('Patient ID: ');
    final patientId = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

    print('Staff:');
    for (var s in staffList) {
      print('${s['staff_id']}: ${s['full_name']}');
    }
    stdout.write('Assigned By Staff ID: ');
    final staffId = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

    final assignment = RoomAssignment(
      bedId: bedId,
      patientId: patientId,
      assignedBy: staffId,
    );
    final id = await assignment.save();
    print('Room Assignment created with ID: $id');
  }

  // =================== View Methods ===================
  Future<void> viewWards() async {
    printHeader('All Wards');
    final wards = await Ward.getAll();
    if (wards.isEmpty) print('No wards found.');
    for (var w in wards) print(w);
  }

  Future<void> viewRooms() async {
    printHeader('All Rooms');
    final rooms = await Room.getAll();
    if (rooms.isEmpty) print('No rooms found.');
    for (var r in rooms) print(r);
  }

  Future<void> viewBeds() async {
    printHeader('All Beds');
    final beds = await Bed.getAll();
    if (beds.isEmpty) print('No beds found.');
    for (var b in beds) print(b);
  }

  Future<void> viewPatients() async {
    printHeader('All Patients');
    final patients = await Patient.getAll();
    if (patients.isEmpty) print('No patients found.');
    for (var p in patients) print(p);
  }

  Future<void> viewStaff() async {
    printHeader('All Staff');
    final staffList = await Staff.getAll();
    if (staffList.isEmpty) print('No staff found.');
    for (var s in staffList) print(s);
  }

  Future<void> viewAssignments() async {
    printHeader('All Room Assignments');
    final assignments = await RoomAssignment.getActiveAssignments();
    if (assignments.isEmpty) print('No assignments found.');
    for (var a in assignments) print(a);
  }
}
