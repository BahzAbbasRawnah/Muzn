import 'package:muzn/models/enums.dart';

class CircleStudent {
  final int id;
  final String name;
  final String? phoneNumber;
  final String? email;
  final AttendanceStatuse? todayAttendance;

  CircleStudent({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.email,
    this.todayAttendance,
  });

  factory CircleStudent.fromMap(Map<String, dynamic> map) {
    return CircleStudent(
      id: map['student_id'] as int,
      name: map['full_name'] as String,
      phoneNumber: map['phone'] as String?,
      email: map['email'] as String?,
      todayAttendance: map['today_attendance'] != null
          ? AttendanceStatuse.values.firstWhere(
              (e) => e.name == (map['today_attendance'] as String),
              orElse: () => AttendanceStatuse.none,
            )
          : null,
    );
  }
}
