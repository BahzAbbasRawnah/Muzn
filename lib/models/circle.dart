class Circle {
  final int id;
  final int? schoolId;
  final int teacherId;
  final String name;
  final String? description;
  final int? circleCategoryId;
  final String? circleType;
  final String? circleTime;
  final String? jitsiLink;
  final String? recordingUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  int? studentCount; // Count of students in this circle
  String? categoryName; // Name of the circle category
  String? schoolName; // Name of the school

  Circle({
    required this.id,
    this.schoolId,
    required this.teacherId,
    required this.name,
    this.description,
    this.circleCategoryId,
    this.circleType,
    this.circleTime,
    this.jitsiLink,
    this.recordingUrl,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.studentCount,
    this.categoryName,
    this.schoolName,
  });

  factory Circle.fromMap(Map<String, dynamic> map) {
    return Circle(
      id: map['id'] as int,
      schoolId: map['school_id'] as int?,
      teacherId: map['teacher_id'] as int,
      name: map['name'] as String,
      description: map['description'] as String?,
      circleCategoryId: map['circle_category_id'] as int?,
      circleType: map['circle_type'] as String?,
      circleTime: map['circle_time'] as String?,
      jitsiLink: map['jitsi_link'] as String?,
      recordingUrl: map['recording_url'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      deletedAt: map['deleted_at'] != null 
          ? DateTime.parse(map['deleted_at'] as String)
          : null,
      studentCount: map['student_count'] as int?,
      categoryName: map['category_name'] as String?,
      schoolName: map['school_name'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'school_id': schoolId,
      'teacher_id': teacherId,
      'name': name,
      'description': description,
      'circle_category_id': circleCategoryId,
      'circle_type': circleType,
      'circle_time': circleTime,
      'jitsi_link': jitsiLink,
      'recording_url': recordingUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  Circle copyWith({
    int? id,
    int? schoolId,
    int? teacherId,
    String? name,
    String? description,
    int? circleCategoryId,
    String? circleType,
    String? circleTime,
    String? jitsiLink,
    String? recordingUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? studentCount,
    String? categoryName,
    String? schoolName,
  }) {
    return Circle(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      teacherId: teacherId ?? this.teacherId,
      name: name ?? this.name,
      description: description ?? this.description,
      circleCategoryId: circleCategoryId ?? this.circleCategoryId,
      circleType: circleType ?? this.circleType,
      circleTime: circleTime ?? this.circleTime,
      jitsiLink: jitsiLink ?? this.jitsiLink,
      recordingUrl: recordingUrl ?? this.recordingUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      studentCount: studentCount ?? this.studentCount,
      categoryName: categoryName ?? this.categoryName,
      schoolName: schoolName ?? this.schoolName,
    );
  }
}
