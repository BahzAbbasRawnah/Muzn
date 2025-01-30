import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:muzn/models/user_model.dart';
import 'package:muzn/services/database_service.dart';
import 'package:muzn/services/local_database.dart';
import 'package:muzn/utils/request_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // ================== User Table Operations ==================
 // Register a new user
Future<RequestStatus> registerUser(User user) async {
  try {
    // Check if user already exists with the given email
    final existingUser = await _databaseHelper.getUserByEmail(user.email);
    if (existingUser != null) {
      return RequestStatus.failure("Email already registered!");
    }

    // Convert User object to a map
    final userMap = user.toMap();

    // Insert the user into the database
    int result = await _databaseHelper.insertUser(userMap);

    if (result > 0) {
      return RequestStatus.success("User registered successfully!");
    } else {
      return RequestStatus.failure("Registration failed!");
    }
  } catch (e) {
    return RequestStatus.failure("Error: $e");
  }
}



  /// Login a user by email and password
 Future<RequestStatus<Map<String, dynamic>>> loginUser(String email, String password) async {
  try {
    // Fetch the user from the database
    final user = await _databaseHelper.getUserByEmail(email);

    // Check if the user exists
    if (user == null) {
      return RequestStatus.failure("User not found!");
    }

    // Validate the password
    if (user['password'] != password) {
      return RequestStatus.failure("Incorrect password!");
    }

    // Return success with user data
    return RequestStatus.success("Login successful!", user);
  } catch (e) {
    return RequestStatus.failure("Error: $e");
  }
}

    /// Logout the current user (clear session/token)
  Future<String> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool result = await prefs.clear();  
      
      if (result) {
        return "Logout successful!";
      } else {
        return "Logout failed!";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  /// Get a user by ID
  Future<User?> getUserById(int id) async {
    try {
      final userMap = await _databaseHelper.getUserById(id);
      if (userMap != null) {
        return User.fromMap(userMap);
      }
      return null;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  /// Get all users
  Future<List<User>> getAllUsers() async {
    try {
      final usersMap = await _databaseHelper.getAllUsers();
      return usersMap.map((userMap) => User.fromMap(userMap)).toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  /// Update a user
  Future<String> updateUser(User user) async {
    try {
      final userMap = user.toMap();
      int result = await _databaseHelper.updateUser(userMap);

      if (result > 0) {
        return "User updated successfully!";
      } else {
        return "Update failed!";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  /// Delete a user by ID
  Future<String> deleteUser(int id) async {
    try {
      int result = await _databaseHelper.deleteUser(id);

      if (result > 0) {
        return "User deleted successfully!";
      } else {
        return "Delete failed!";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
 // Convert a User object into a JSON string
  static String toJson(User user) {
    return jsonEncode(user.toMap()); // Convert map to JSON string
  }

  // Save the current user to SharedPreferences
  Future<void> saveToSharedPreferences(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = toJson(user); // Use toJson here
      await prefs.setString('current_user', userJson);
    } catch (e) {
      print('Error saving user data to SharedPreferences: $e');
    }
  }

  // Retrieve the current user from SharedPreferences
  static Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString('current_user');

      if (userString == null) return null; // Return null if no user is found

      final userMap = jsonDecode(userString) as Map<String, dynamic>;
      return User.fromMap(userMap);
    } catch (e) {
      print('Error parsing user data: $e');
      return null; // Return null in case of an error
    }
  }
}

