class HomeWork {
  int? id;
  int? circleId;
  int? studentId;
  int startSurahNumber;
  int endSurahNumber;
  int startAyahNumber;
  int endAyahNumber;
  DateTime lessonDate;
  int circleCategoryId;
  String? notes;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  // Constructor
  HomeWork({
    this.id,
    this.circleId,
    this.studentId,
    required this.startSurahNumber,
    required this.endSurahNumber,
    required this.startAyahNumber,
    required this.endAyahNumber,
    required this.lessonDate,
    required this.circleCategoryId,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  // Map to Object (fromMap)
  factory HomeWork.fromMap(Map<String, dynamic> map) {
    return HomeWork(
      id: map['id'] as int?,
      circleId: map['circle_id'] as int?,
      studentId: map['student_id'] as int?,
      startSurahNumber: map['start_surah_number'] as int,
      endSurahNumber: map['end_surah_number'] as int,
      startAyahNumber: map['start_ayah_number'] as int,
      endAyahNumber: map['end_ayah_number'] as int,
      lessonDate: DateTime.parse(map['lesson_date']),
      circleCategoryId: map['circle_category_id'] as int,
      notes: map['notes'] as String?,
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
      'start_surah_number': startSurahNumber,
      'end_surah_number': endSurahNumber,
      'start_ayah_number': startAyahNumber,
      'end_ayah_number': endAyahNumber,
      'lesson_date': lessonDate.toIso8601String(),
      'circle_category_id': circleCategoryId,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
