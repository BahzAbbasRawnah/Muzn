class StudentProgress {
  int? id;
  int? circleId;
  int? studentId;
  String status;
  int startSurahNumber;
  int endSurahNumber;
  int startAyahNumber;
  int endAyahNumber;
  DateTime lessonDate;
  int readingWrong;
  int tajweedWrong;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  // Constructor
  StudentProgress({
    this.id,
    this.circleId,
    this.studentId,
    this.status = 'none', // Default value
    required this.startSurahNumber,
    required this.endSurahNumber,
    required this.startAyahNumber,
    required this.endAyahNumber,
    required this.lessonDate,
    this.readingWrong = 0, // Default value
    this.tajweedWrong = 0, // Default value
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  // Map to Object (fromMap)
  factory StudentProgress.fromMap(Map<String, dynamic> map) {
    return StudentProgress(
      id: map['id'] as int?,
      circleId: map['circle_id'] as int?,
      studentId: map['student_id'] as int?,
      status: map['status'] as String? ?? 'none',
      startSurahNumber: map['start_surah_number'] as int,
      endSurahNumber: map['end_surah_number'] as int,
      startAyahNumber: map['start_ayah_number'] as int,
      endAyahNumber: map['end_ayah_number'] as int,
      lessonDate: DateTime.parse(map['lesson_date']),
      readingWrong: map['reading_wrong'] as int? ?? 0,
      tajweedWrong: map['tajweed_wrong'] as int? ?? 0,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
    );
  }

  // Object to Map (toMap)
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
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
