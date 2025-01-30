class Circle {
  int? id;
  int? schoolMosqueId;
  int? teacherId;
  String name;
  String? description;
  int? circleCategoryId;
  String circleType;
  String circleTime;
  String? jitsiLink;
  String? recordingUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  // Constructor
  Circle({
    this.id,
    this.schoolMosqueId,
    this.teacherId,
    required this.name,
    this.description,
    this.circleCategoryId,
    this.circleType = 'offline', // Default value
    required this.circleTime,
    this.jitsiLink,
    this.recordingUrl,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  // Map to Object (fromMap)
  factory Circle.fromMap(Map<String, dynamic> map) {
    return Circle(
      id: map['id'] as int?,
      schoolMosqueId: map['school_mosque_id'] as int?,
      teacherId: map['teacher_id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String?,
      circleCategoryId: map['circle_category_id'] as int?,
      circleType: map['circle_type'] as String? ?? 'offline',
      circleTime: map['circle_time'] as String,
      jitsiLink: map['jitsi_link'] as String?,
      recordingUrl: map['recording_url'] as String?,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
    );
  }

  // Object to Map (toMap)
Map<String, dynamic> toMap() {
  return {
    'id': id,
    'school_mosque_id': schoolMosqueId,
    'teacher_id': teacherId,
    'name': name,
    'description': description,
    'circle_category_id': circleCategoryId,
    'circle_type': circleType ?? 'offline',
    'circle_time': circleTime,
    'jitsi_link': jitsiLink,
    'recording_url': recordingUrl,
    'created_at': createdAt != null ? createdAt!.toIso8601String() : null,
    'updated_at': updatedAt != null ? updatedAt!.toIso8601String() : null,
    'deleted_at': deletedAt != null ? deletedAt!.toIso8601String() : null,
  };
}

}
