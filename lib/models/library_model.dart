class DigitalLibrary {
  int? id;
  String title;
  String? author;
  String? category;
  String fileUrl;
  int? teacherId;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  // Constructor
  DigitalLibrary({
    this.id,
    required this.title,
    this.author,
    this.category,
    required this.fileUrl,
    this.teacherId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  // Map to Object (fromMap)
  factory DigitalLibrary.fromMap(Map<String, dynamic> map) {
    return DigitalLibrary(
      id: map['id'] as int?,
      title: map['title'] as String,
      author: map['author'] as String?,
      category: map['category'] as String?,
      fileUrl: map['file_url'] as String,
      teacherId: map['teacher_id'] as int?,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
    );
  }

  // Object to Map (toMap)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'category': category,
      'file_url': fileUrl,
      'teacher_id': teacherId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
