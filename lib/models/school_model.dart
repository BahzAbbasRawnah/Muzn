import 'package:muzn/models/user_model.dart';

class School {
  final int? id;
  final int teacherId; // Foreign key referencing the User table (teacher)
  final String name;
  final String? type;
  final String? address;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  // Nested relationship: Teacher (User)
  final User? teacher;

  School({
    this.id,
    required this.teacherId,
    required this.name,
    this.type,
    this.address,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.teacher, // Optional nested relationship
  });

  // Factory method to create a School object from a JSON map
  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      teacherId: json['teacher_id'],
      name: json['name'],
      type: json['type'],
      address: json['address'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      teacher: json['teacher'] != null ? User.fromJson(json['teacher']) : null, // Nested relationship
    );
  }

  // Method to convert a School object to a JSON map (exclude nested objects for database operations)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacher_id': teacherId,
      'name': name,
      'type': type,
      'address': address,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      // Exclude 'teacher' field as it's not a column in the database
    };
  }
}