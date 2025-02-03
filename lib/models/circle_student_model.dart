import 'package:muzn/models/circle_model.dart';
import 'package:muzn/models/user_model.dart';

class CircleStudent {
  final int? id;
  final int circleId; // Foreign key referencing the Circle table
  final int studentId; // Foreign key referencing the User table (student)
  final int teacherId; // Foreign key referencing the User table (teacher)
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  // Nested relationships: Circle, Student (User), Teacher (User)
  final Circle? circle;
  final User? student;
  final User? teacher;

  CircleStudent({
    this.id,
    required this.circleId,
    required this.studentId,
    required this.teacherId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.circle, // Optional nested relationship
    this.student, // Optional nested relationship
    this.teacher, // Optional nested relationship
  });

  // Factory method to create a CircleStudent object from a JSON map
  factory CircleStudent.fromJson(Map<String, dynamic> json) {
    return CircleStudent(
      id: json['id'],
      circleId: json['circle_id'],
      studentId: json['student_id'],
      teacherId: json['teacher_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      circle: json['circle'] != null ? Circle.fromJson(json['circle']) : null, // Nested relationship
      student: json['student'] != null ? User.fromJson(json['student']) : null, // Nested relationship
      teacher: json['teacher'] != null ? User.fromJson(json['teacher']) : null, // Nested relationship
    );
  }

  // Method to convert a CircleStudent object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'circle_id': circleId,
      'student_id': studentId,
      'teacher_id': teacherId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'circle': circle?.toJson(), // Nested relationship
      'student': student?.toJson(), // Nested relationship
      'teacher': teacher?.toJson(), // Nested relationship
    };
  }
}