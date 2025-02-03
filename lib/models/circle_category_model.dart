class CirclesCategory {
  final int? id;
  final String name;
  final String nameValue;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  CirclesCategory({
    this.id,
    required this.name,
    required this.nameValue,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  // Factory method to create a CirclesCategory object from a JSON map
  factory CirclesCategory.fromJson(Map<String, dynamic> json) {
    return CirclesCategory(
      id: json['id'],
      name: json['name'],
      nameValue: json['namevalue'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  // Method to convert a CirclesCategory object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'namevalue': nameValue,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
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
