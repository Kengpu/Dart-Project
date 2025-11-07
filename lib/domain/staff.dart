import '../data/csv_database.dart';

class Staff {
  static const headers = [
    'staff_id',
    'employee_number',
    'full_name',
    'role',
    'department',
    'phone',
    'email',
    'is_active'
  ];

  // Changed from const to static so it can be overridden in tests
  static String filePath = 'hospital_data/staff.csv';

  int? staffId;
  String employeeNumber;
  String fullName;
  String role; // Doctor, Nurse, Technician, Housekeeper, Admin, Manager
  String department;
  String phone;
  String email;
  bool isActive;

  Staff({
    this.staffId,
    required this.employeeNumber,
    required this.fullName,
    required this.role,
    required this.department,
    this.phone = '',
    this.email = '',
    this.isActive = true,
  });

  Future<int> save() async {
    staffId ??= await CSVDatabase.getNextId(filePath, 'staff_id');
    final data = {
      'staff_id': staffId,
      'employee_number': employeeNumber,
      'full_name': fullName,
      'role': role,
      'department': department,
      'phone': phone,
      'email': email,
      'is_active': isActive,
    };
    await CSVDatabase.appendCsv(filePath, headers, data);
    return staffId!;
  }

  static Future<List<Map<String, dynamic>>> getAll() => CSVDatabase.readCsv(filePath);
}
