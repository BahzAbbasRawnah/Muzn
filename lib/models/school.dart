  class School {
  final int id;
   String? uuid;
  final int? teacherId;
   String? teacherUuid;
  final String name;
  final String? type;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  int? circleCount;

  School({
    required this.id,
     this.uuid,
    this.teacherId,
    this.teacherUuid,
    required this.name,
    this.type,
    this.address,
   this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.circleCount,
  });

factory School.fromMap(Map<String, dynamic> map) {
  return School(
    id: map['id'] as int,
    uuid: map['uuid'] as String,
    teacherId: map['teacher_id'] as int?,
    teacherUuid: map['teacher_uuid'] as String?,
    name: map['name'] as String,
    type: map['type'] as String? ?? '', // Provide a default value if null
    address: map['address'] as String? ?? '', // Provide a default value if null
    createdAt: map['created_at'] != null ? DateTime.parse(map['created_at'] as String) : null,
    updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at'] as String) : null,
    deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at'] as String) : null,
    circleCount: map['circle_count'] as int?,
  );
}

Map<String, dynamic> toMap() {
  return {
    'id': id,
    'uuid': uuid,
    'teacher_id': teacherId,
    'teacher_uuid': teacherUuid,
    'name': name,
    'type': type,
    'address': address,
    'created_at': createdAt?.toIso8601String(), // Handle null
    'updated_at': updatedAt?.toIso8601String(), // Handle null
    'deleted_at': deletedAt?.toIso8601String(), // Handle null
  };
}

  School copyWith({
    int? id,
    int? teacherId,
    String? name,
    String? type,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? circleCount,
  }) {
    return School(
      id: id ?? this.id,
      uuid: uuid??uuid,
      teacherId: teacherId ?? this.teacherId,
      name: name ?? this.name,
      type: type ?? this.type,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      circleCount: circleCount ?? this.circleCount,
    );
  }
}
