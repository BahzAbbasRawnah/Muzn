
import 'package:muzn/models/user.dart';

class Student {
  final int id;
   String? uuid;
  final int teacherId;
   String? teacherUuid;
  final int userId;
   String? userUuid;
   DateTime? createdAt;
   DateTime? updatedAt;
   DateTime? deletedAt;
   User? user; // Optional User object

  Student({
    required this.id,
     this.uuid,
    required this.teacherId,
    required this.userId,
     this.teacherUuid,
     this.userUuid,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user, // Optional User object
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    print('map inside student ');
    print(map);
    return Student(
      id: map['id'] as int,
      uuid: map['uuid'] as String,
      teacherId: map['teacher_id'] as int,
      teacherUuid: map['teacher_uuid'] as String,
      userId: map['user_id'] as int,
      userUuid: map['user_uuid'] as String,
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
      'uuid': uuid,
      'teacher_id': teacherId,
      'teacher_uuid': teacherUuid,
      'user_id': userId,
      'user_uuid': userUuid,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'user': user?.toMap(), // Optional User object
    };
  }


}