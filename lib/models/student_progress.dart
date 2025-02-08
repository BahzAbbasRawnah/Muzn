class StudentProgress {
  final int id;
  final int circleId;
  final int studentId;
  final String status;
  final int startSurahNumber;
  final int endSurahNumber;
  final int startAyahNumber;
  final int endAyahNumber;
  final DateTime lessonDate;
  final int readingWrong;
  final int tajweedWrong;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  StudentProgress({
    required this.id,
    required this.circleId,
    required this.studentId,
    required this.status,
    required this.startSurahNumber,
    required this.endSurahNumber,
    required this.startAyahNumber,
    required this.endAyahNumber,
    required this.lessonDate,
    required this.readingWrong,
    required this.tajweedWrong,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory StudentProgress.fromMap(Map<String, dynamic> map) {
    return StudentProgress(
      id: map['id'],
      circleId: map['circle_id'],
      studentId: map['student_id'],
      status: map['status'],
      startSurahNumber: map['start_surah_number'],
      endSurahNumber: map['end_surah_number'],
      startAyahNumber: map['start_ayah_number'],
      endAyahNumber: map['end_ayah_number'],
      lessonDate: DateTime.parse(map['lesson_date']),
      readingWrong: map['reading_wrong'],
      tajweedWrong: map['tajweed_wrong'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'circle_id': circleId,
      'student_id': studentId,
      'status': status,
      'start_surah_number': startSurahNumber,
      'end_surah_number': endSurahNumber,
      'start_ayah_number': startAyahNumber,
      'end_ayah_number': endAyahNumber,
      'lesson_date': lessonDate.toIso8601String(),
      'reading_wrong': readingWrong,
      'tajweed_wrong': tajweedWrong,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
