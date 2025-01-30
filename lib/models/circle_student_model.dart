class CircleStudent {
  int? id;
  int? circleId;
  int? studentId;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  // Constructor
  CircleStudent({
    this.id,
    this.circleId,
    this.studentId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  // Map to Object (fromMap)
  factory CircleStudent.fromMap(Map<String, dynamic> map) {
    return CircleStudent(
      id: map['id'] as int?,
      circleId: map['circle_id'] as int?,
      studentId: map['student_id'] as int?,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
    );
  }

  // Object to Map (toMap)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'circle_id': circleId,
      'student_id': studentId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
