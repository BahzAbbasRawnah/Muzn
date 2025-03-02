import 'enums.dart';

class AttendanceRecord {
  final int id;
  final int studentId;
  final int circleId;
  final DateTime attendanceDate;
  final AttendanceStatuse status;

  AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.circleId,
    required this.attendanceDate,
    required this.status,
  });
}
