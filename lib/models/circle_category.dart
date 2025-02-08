class CircleCategory {
  final int id;
  final String name;
  final String? description;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  CircleCategory({
    required this.id,
    required this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory CircleCategory.fromMap(Map<String, dynamic> map) {
    return CircleCategory(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String?,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
      deletedAt: map['deleted_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
