class User {
  final int? id;
  final String fullName;
  final String email;
  final String password; // Ensure this is hashed before storing
  final String? phone;
  final String? country;
  final String gender;
  final String role;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  User({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    this.phone,
    this.country,
    required this.gender,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  // Factory method to create a User object from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      password: json['password'], // Ensure this is hashed
      phone: json['phone'],
      country: json['country'],
      gender: json['gender'],
      role: json['role'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  // Method to convert a User object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'password': password, // Ensure this is hashed
      'phone': phone,
      'country': country,
      'gender': gender,
      'role': role,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}