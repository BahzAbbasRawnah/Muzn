import 'package:muzn/models/circle_model.dart';
import 'package:muzn/models/user_model.dart';

class Student {
  final int? id;
  final int userId; // Foreign key referencing the User table
  final int circleId; // Foreign key referencing the Circle table
  final DateTime enrollmentDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  // Nested relationships: User and Circle
  final User? user;
  final Circle? circle;

  Student({
    this.id,
    required this.userId,
    required this.circleId,
    required this.enrollmentDate,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.user, // Optional nested relationship
    this.circle, // Optional nested relationship
  });

  // Factory method to create a Student object from a JSON map
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      userId: json['user_id'],
      circleId: json['circle_id'],
      enrollmentDate: DateTime.parse(json['enrollment_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null, // Nested relationship
      circle: json['circle'] != null ? Circle.fromJson(json['circle']) : null, // Nested relationship
    );
  }

  // Method to convert a Student object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'circle_id': circleId,
      'enrollment_date': enrollmentDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'user': user?.toJson(), // Nested relationship
      'circle': circle?.toJson(), // Nested relationship
    };
  }
}