class Homework {
  final int id;
   String? uuid;
  final int circleId;
   String? circleUuid;
  final int circleCategoryId;
   String? circleCategoryUuid;
  String? categoryName;
  final int studentId;
   String? studentUuid;
  final int? checked;
  final int startSurahNumber;
  final int endSurahNumber;
  final int startAyahNumber;
  final int endAyahNumber;
  final DateTime homeworkDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Homework({
    required this.id,
    this.uuid,
    required this.circleId,
    this.circleUuid,
    required this.circleCategoryId,
    required this.studentId,
    this.studentUuid,
    this.circleCategoryUuid,
    required this.startSurahNumber,
    required this.endSurahNumber,
    required this.startAyahNumber,
    required this.endAyahNumber,
    required this.homeworkDate,
    this.notes,
    this.categoryName,
    this.checked,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Homework.fromMap(Map<String, dynamic> map) {
    return Homework(
      id: map['id'],
      uuid: map['uuid'],
      circleId: map['circle_id'],
      circleUuid: map['circle_uuid'],
      circleCategoryId: map['circle_category_id'],
      circleCategoryUuid: map['circle_category_uuid'],
      categoryName: map['category_name'],
      studentId: map['student_id'],
      studentUuid: map['student_uuid'],
      checked: map['checked'],
      startSurahNumber: map['start_surah_number'],
      endSurahNumber: map['end_surah_number'],
      startAyahNumber: map['start_ayah_number'],
      endAyahNumber: map['end_ayah_number'],
      homeworkDate: DateTime.parse(map['homework_date']),
      notes: map['notes'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uuid': uuid,
      'circle_id': circleId,
      'circle_uuid': circleUuid,
      'circle_category_id': circleCategoryId,
      'circle_category_uuid': circleCategoryUuid,
      'student_id': studentId,
      'student_uuid': studentUuid,
      'checked':checked,
      'start_surah_number': startSurahNumber,
      'end_surah_number': endSurahNumber,
      'start_ayah_number': startAyahNumber,
      'end_ayah_number': endAyahNumber,
      'homework_date': homeworkDate.toIso8601String(),
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
  Map<String, dynamic> toMapWithoutUuid() {
    return {
      'id': id,
      // 'uuid': uuid,
      'circle_id': circleId,
      'circle_uuid': circleUuid,
      'circle_category_id': circleCategoryId,
      'circle_category_uuid': circleCategoryUuid,
      'student_id': studentId,
      'student_uuid': studentUuid,
      'checked':checked,
      'start_surah_number': startSurahNumber,
      'end_surah_number': endSurahNumber,
      'start_ayah_number': startAyahNumber,
      'end_ayah_number': endAyahNumber,
      'homework_date': homeworkDate.toIso8601String(),
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
