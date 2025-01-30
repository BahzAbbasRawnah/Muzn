import 'package:muzn/models/user_model.dart';

class Student {
  int? id;
  int? teacherId;
  User user;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  // Constructor
  Student({
    this.id,
    this.teacherId,
    required this.user,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  // Map to Object (fromMap)
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as int?,
      teacherId: map['teacher_id'] as int?,
      user: map['user'] as User,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
    );
  }

  // Object to Map (toMap)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teacher_id': teacherId,
      'user': user,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
  enum StudentStatus {
  none,
  present,
  absent,
  excused,
  late,
  permissionGranted,
  notHeard,
}


