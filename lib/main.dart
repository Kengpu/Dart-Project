// lib/main.dart
import 'data/json_database.dart';
import 'service/hospital_service.dart';
import 'ui/console_ui.dart';

void main() async {
  final db = JsonDatabase('data/hospital.json');
  final service = HospitalService(db);

  await service.load();

  final ui = ConsoleUI(service);
  await ui.start();
}
  