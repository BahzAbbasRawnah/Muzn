class StatisticsStudent {
  final int id;
  final String fullName;
  final int attendanceCount;

  const StatisticsStudent({
    required this.id,
    required this.fullName,
    required this.attendanceCount,
  });

  factory StatisticsStudent.fromMap(Map<String, dynamic> map) {
    return StatisticsStudent(
      id: map['student_id'] as int,
      fullName: map['full_name'] as String,
      attendanceCount: map['count'] as int,
    );
  }
}
