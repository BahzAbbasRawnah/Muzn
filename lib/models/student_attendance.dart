import 'package:muzn/models/enums.dart';

class StudentAttendance {
  final int id;
  final int studentId;
  final int circleId;
  final DateTime attendanceDate;
  final AttendanceStatuse status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  StudentAttendance({
    required this.id,
    required this.studentId,
    required this.circleId,
    required this.attendanceDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory StudentAttendance.fromMap(Map<String, dynamic> map) {
    return StudentAttendance(
      id: map['id'] as int,
      studentId: map['student_id'] as int,
      circleId: map['circle_id'] as int,
      attendanceDate: DateTime.parse(map['attendance_date'] as String),
      status: AttendanceStatuse.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => AttendanceStatuse.none,
      ),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      deletedAt: map['deleted_at'] != null
          ? DateTime.parse(map['deleted_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'circle_id': circleId,
      'attendance_date': attendanceDate.toIso8601String(),
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
