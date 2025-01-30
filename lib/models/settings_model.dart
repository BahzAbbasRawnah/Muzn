class Settings {
  int? id;
  String name;
  String? logoUrl;
  String? address;
  String? phone;
  String? email;
  String? websiteUrl;
  String? videoServerUrl;
  String? supportEmail;
  String? socialMediaLinks;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  // Constructor
  Settings({
    this.id,
    required this.name,
    this.logoUrl,
    this.address,
    this.phone,
    this.email,
    this.websiteUrl,
    this.videoServerUrl,
    this.supportEmail,
    this.socialMediaLinks,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  // Map to Object (fromMap)
  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      id: map['id'] as int?,
      name: map['name'] as String,
      logoUrl: map['logo_url'] as String?,
      address: map['address'] as String?,
      phone: map['phone'] as String?,
      email: map['email'] as String?,
      websiteUrl: map['website_url'] as String?,
      videoServerUrl: map['video_server_url'] as String?,
      supportEmail: map['support_email'] as String?,
      socialMediaLinks: map['social_media_links'] as String?,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
    );
  }

  // Object to Map (toMap)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'logo_url': logoUrl,
      'address': address,
      'phone': phone,
      'email': email,
      'website_url': websiteUrl,
      'video_server_url': videoServerUrl,
      'support_email': supportEmail,
      'social_media_links': socialMediaLinks,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
