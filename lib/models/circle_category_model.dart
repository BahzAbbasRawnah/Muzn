class CirclesCategory {
  final int id;
  final String name;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  CirclesCategory({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  // Factory constructor to create an object from a Map
  factory CirclesCategory.fromMap(Map<String, dynamic> map) {
    return CirclesCategory(
      id: map['id'] as int,
      name: map['name'] as String,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
    );
  }

  // Convert object to Map (toMap)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}


enum CircleTime {
  morning,
  noon,
  afternoon,
  maghrib,
  evening,
}
enum CircleType {
  online,
  offline,
}
