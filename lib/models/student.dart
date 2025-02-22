
import 'package:muzn/models/user.dart';

class Student {
  final int id;
  final int teacherId;
  final int userId;
   DateTime? createdAt;
   DateTime? updatedAt;
   DateTime? deletedAt;
  final User? user; // Optional User object

  Student({
    required this.id,
    required this.teacherId,
    required this.userId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user, // Optional User object
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as int,
      teacherId: map['teacher_id'] as int,
      userId: map['user_id'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      deletedAt: map['deleted_at'] != null
          ? DateTime.parse(map['deleted_at'] as String)
          : null,
      user: map['user'] != null ? User.fromMap(map['user']) : null, // Optional User object
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teacher_id': teacherId,
      'user_id': userId,
      'created_at': createdAt!.toIso8601String(),
      'updated_at': updatedAt!.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'user': user?.toMap(), // Optional User object
    };
  }


}