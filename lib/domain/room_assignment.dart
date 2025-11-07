import '../data/csv_database.dart';
import 'bed.dart';

class RoomAssignment {
  static const headers = [
    'assignment_id',
    'bed_id',
    'patient_id',
    'assigned_by',
    'admission_date',
    'expected_discharge',
    'actual_discharge',
    'admission_type',
    'priority',
    'notes'
  ];

  static String filePath = 'hospital_data/room_assignments.csv'; // <-- change here

  int? assignmentId;
  int bedId;
  int patientId;
  int assignedBy;
  String admissionDate;
  String expectedDischarge;
  String actualDischarge;
  String admissionType; // Emergency, Scheduled, Transfer
  String priority; // Critical, High, Normal, Low
  String notes;

  RoomAssignment({
    this.assignmentId,
    required this.bedId,
    required this.patientId,
    required this.assignedBy,
    this.admissionType = 'Scheduled',
    this.priority = 'Normal',
    this.expectedDischarge = '',
    this.notes = '',
  })  : admissionDate = DateTime.now().toString(),
        actualDischarge = '';

  Future<int> save() async {
    assignmentId ??= await CSVDatabase.getNextId(filePath, 'assignment_id');
    final data = {
      'assignment_id': assignmentId,
      'bed_id': bedId,
      'patient_id': patientId,
      'assigned_by': assignedBy,
      'admission_date': admissionDate,
      'expected_discharge': expectedDischarge,
      'actual_discharge': actualDischarge,
      'admission_type': admissionType,
      'priority': priority,
      'notes': notes,
    };
    await CSVDatabase.appendCsv(filePath, headers, data);
    await Bed.updateStatus(bedId, 'Occupied');
    return assignmentId!;
  }

  static Future<void> discharge(int assignmentId) async {
    final assignments = await getAll();
    for (var a in assignments) {
      if (int.parse(a['assignment_id'].toString()) == assignmentId) {
        a['actual_discharge'] = DateTime.now().toString();
        final bedId = int.parse(a['bed_id'].toString());
        await Bed.updateStatus(bedId, 'Available');
        break;
      }
    }
    await CSVDatabase.writeCsv(filePath, headers, assignments);
  }

  static Future<List<Map<String, dynamic>>> getAll() => CSVDatabase.readCsv(filePath);

  static Future<List<Map<String, dynamic>>> getActiveAssignments() async {
    final assignments = await getAll();
    return assignments.where((a) => a['actual_discharge'].toString().isEmpty).toList();
  }
}
