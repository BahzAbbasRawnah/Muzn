class User {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String? country;
  final String? countryCode;
  final String? password;
  final String gender;
  final String role;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.country,
    this.countryCode,
    this.password,
    required this.gender,
    required this.role,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      fullName: map['full_name'],
      email: map['email'],
      phone: map['phone'],
      country: map['country'],
      countryCode: map['country_code'],
      gender: map['gender'],
      role: map['role'],
      password: map['password'] as String?,
      status: map['status'] as String?,
      createdAt:map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      deletedAt: map['deleted_at'] != null ? DateTime.parse(map['deleted_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'password': password!,
      'country': country,
      'country_code':countryCode,
      'gender': gender,
      'role': role,
      'status': status,
      'created_at': createdAt!.toIso8601String(),
      'updated_at': updatedAt!.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
