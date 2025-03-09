

import 'package:muzn/models/enums.dart';

class StudentProgress {
  final int id;
   String? uuid;
  final int circleId;
   String? circleUuid;
  final int studentId;
   String? studentUuid;
  final int homeworkId;
   String? homeworkUuid;
  final Rating readingRating;
  final Rating reviewRating;
  final Rating telawahRating;
  final int readingWrong;
  final int tajweedWrong;
  final int tashqeelWrong;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;


  StudentProgress({
    required this.id,
    this.uuid,
    // this.uuid,
    required this.circleId,
    this.circleUuid,
    required this.studentId,
    this.studentUuid,

    required this.homeworkId,
    this.homeworkUuid,
    required this.readingRating,
    required this.reviewRating,
    required this.telawahRating,
    required this.readingWrong,
    required this.tajweedWrong,
    required this.tashqeelWrong,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory StudentProgress.fromMap(Map<String, dynamic> map) {
    return StudentProgress(
      id: map['id'],
      uuid: map['uuid'],
      circleId: map['circle_id'],
      circleUuid: map['circle_uuid'],
      studentId: map['student_id'],
      studentUuid: map['student_uuid'],
      homeworkId: map['homework_id'],
      homeworkUuid: map['homework_uuid'],
    readingRating: Rating.values.firstWhere(
      (e) => e.name == map['reading_rating'].toString(),
      orElse: () => Rating.excellent, // Default if value is invalid
    ),
    reviewRating: Rating.values.firstWhere(
      (e) => e.name == map['review_rating'].toString(),
      orElse: () => Rating.good, // Default
    ),
    telawahRating: Rating.values.firstWhere(
      (e) => e.name == map['telawah_rating'].toString(),
      orElse: () => Rating.weak, // Default
    ),
      readingWrong: map['reading_wrong'],
      tajweedWrong: map['tajweed_wrong'],
      tashqeelWrong: map['tashqeel_wrong'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      // 'uuid': uuid,
      'circle_id': circleId,
      // 'circle_uuid': circleUuid,
      'student_id': studentId,
      'student_uuid': studentUuid,
      'homework_id': homeworkId,
      'homework_uuid': homeworkUuid,
      'reading_rating': readingRating.name,
      'review_rating': reviewRating.name,
      'telawah_rating': telawahRating.name,
      'reading_wrong': readingWrong,
      'tajweed_wrong': tajweedWrong,
      'tashqeel_wrong': tashqeelWrong,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),

    };
  }
}
