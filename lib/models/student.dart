class Student {
  final int id;
  final int teacherId;
  final int userId;
  final String fullName;  // From User table
  final String email;     // From User table
  final String phone;     // From User table
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Student({
    required this.id,
    required this.teacherId,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      teacherId: map['teacher_id'],
      userId: map['user_id'],
      fullName: map['full_name'],
      email: map['email'],
      phone: map['phone'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teacher_id': teacherId,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
