import 'package:muzn/models/circle_model.dart';
import 'package:muzn/models/user_model.dart';

class StudentProgress {
  final int? id;
  final int circleId; // Foreign key referencing the Circle table
  final int studentId; // Foreign key referencing the Student table
  final String status; // e.g., 'present', 'absent', etc.
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

  // Nested relationships: Circle, Student
  final Circle? circle;
  final User? student;

  StudentProgress({
    this.id,
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
    this.circle, // Optional nested relationship
    this.student, // Optional nested relationship
  });

  // Factory method to create a StudentProgress object from a JSON map
  factory StudentProgress.fromJson(Map<String, dynamic> json) {
    return StudentProgress(
      id: json['id'],
      circleId: json['circle_id'],
      studentId: json['student_id'],
      status: json['status'],
      startSurahNumber: json['start_surah_number'],
      endSurahNumber: json['end_surah_number'],
      startAyahNumber: json['start_ayah_number'],
      endAyahNumber: json['end_ayah_number'],
      lessonDate: DateTime.parse(json['lesson_date']),
      readingWrong: json['reading_wrong'],
      tajweedWrong: json['tajweed_wrong'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      circle: json['circle'] != null ? Circle.fromJson(json['circle']) : null, // Nested relationship
      student: json['student'] != null ? User.fromJson(json['student']) : null, // Nested relationship
    );
  }

  // Method to convert a StudentProgress object to a JSON map
  Map<String, dynamic> toJson() {
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
      'circle': circle?.toJson(), // Nested relationship
      'student': student?.toJson(), // Nested relationship
    };
  }
}