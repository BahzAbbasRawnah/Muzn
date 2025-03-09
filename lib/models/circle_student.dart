import 'package:muzn/models/enums.dart';
import 'package:muzn/models/student.dart';




class CircleStudent {
  final int id;
  final Student student;
  final AttendanceStatuse? todayAttendance;

  CircleStudent({
    required this.id,
    required this.student,
    this.todayAttendance,
  });

  factory CircleStudent.fromMap(Map<String, dynamic> map) {
    print('map iiiiiiiiiiii');
    print(map);
    return CircleStudent(
      id: map['student_id'] as int? ?? 0, 
      student: Student.fromMap(map),
      todayAttendance: map['today_attendance'] != null
          ? AttendanceStatuse.values.firstWhere(
              (e) => e.name == (map['today_attendance'] as String),
              orElse: () => AttendanceStatuse.none,
            )
          : null,
    );
  }
}