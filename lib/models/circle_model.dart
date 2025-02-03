import 'package:muzn/models/circle_category_model.dart';
import 'package:muzn/models/school_model.dart';
import 'package:muzn/models/user_model.dart';

class Circle {
  final int? id;
  final String name;
  final int teacherId;
  final int schoolId;
  final CircleTime circleTime;
  final CircleType circleType;
  final int categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  // Nested relationships: Teacher (User), School, CirclesCategory
  final User? teacher;
  final School? school;
  final CirclesCategory? category;

  Circle({
    this.id,
    required this.name,
    required this.teacherId,
    required this.schoolId,
    required this.categoryId,
    required this.circleTime,
    required this.circleType,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.teacher,
    this.school,
    this.category,
  });

  // Factory method to create a Circle object from a JSON map
  factory Circle.fromJson(Map<String, dynamic> json) {
    return Circle(
      id: json['id'] as int?,
      name: json['name'] as String,
      teacherId: json['teacher_id'] as int,
      schoolId: json['school_id'] as int,
      categoryId: json['category_id'] as int,
      circleTime: CircleTime.values.firstWhere(
          (e) => e.toString().split('.').last == json['circle_time'],
          orElse: () => CircleTime.morning), // Adjust based on your enum
      circleType: CircleType.values.firstWhere(
          (e) => e.toString().split('.').last == json['circle_type'],
          orElse: () => CircleType.offline), // Adjust based on your enum
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      teacher: json['teacher'] != null ? User.fromJson(json['teacher']) : null,
      school: json['school'] != null ? School.fromJson(json['school']) : null,
      category: json['category'] != null
          ? CirclesCategory.fromJson(json['category'])
          : null,
    );
  }

  // Method to convert a Circle object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'teacher_id': teacherId,
      'school_id': schoolId,
      'category_id': categoryId,
      'circle_time': circleTime.toString().split('.').last, // Ensure proper serialization
      'circle_type': circleType.toString().split('.').last, // Ensure proper serialization
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'teacher': teacher?.toJson(),
      'school': school?.toJson(),
      'category': category?.toJson(),
    };
  }
}
