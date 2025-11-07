import '../data/csv_database.dart';

class Patient {
  static const headers = [
    'patient_id',
    'medical_record_number',
    'full_name',
    'dob',
    'gender',
    'blood_type',
    'emergency_contact',
    'emergency_phone',
    'requires_isolation'
  ];

  static String filePath = 'hospital_data/patients.csv'; // <-- change here

  int? patientId;
  String medicalRecordNumber;
  String fullName;
  String dob;
  String gender;
  String bloodType;
  String emergencyContact;
  String emergencyPhone;
  bool requiresIsolation;

  Patient({
    this.patientId,
    required this.medicalRecordNumber,
    required this.fullName,
    required this.dob,
    required this.gender,
    this.bloodType = '',
    this.emergencyContact = '',
    this.emergencyPhone = '',
    this.requiresIsolation = false,
  });

  Future<int> save() async {
    patientId ??= await CSVDatabase.getNextId(filePath, 'patient_id');
    final data = {
      'patient_id': patientId,
      'medical_record_number': medicalRecordNumber,
      'full_name': fullName,
      'dob': dob,
      'gender': gender,
      'blood_type': bloodType,
      'emergency_contact': emergencyContact,
      'emergency_phone': emergencyPhone,
      'requires_isolation': requiresIsolation,
    };
    await CSVDatabase.appendCsv(filePath, headers, data);
    return patientId!;
  }

  static Future<List<Map<String, dynamic>>> getAll() => CSVDatabase.readCsv(filePath);

  static Future<Map<String, dynamic>?> getById(int id) async {
    final patients = await getAll();
    try {
      return patients.firstWhere((p) => int.parse(p['patient_id'].toString()) == id);
    } catch (_) {
      return null;
    }
  }
}
