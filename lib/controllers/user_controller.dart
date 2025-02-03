import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../repository/user_repository.dart';

class UserController {
  SharedPreferences? _prefs; // Nullable field
  final UserRepository _userRepository = UserRepository(); // Directly initializing

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance(); // Initialize _prefs
  }

  Future<User?> getCurrentUser() async {
    await init(); // Ensure initialization
    if (_prefs == null) {
      throw Exception("SharedPreferences not initialized. Call init() first.");
    }
    final userData = _prefs!.getString('currentUser');
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  Future<void> logout() async {
    if (_prefs == null) {
      throw Exception("SharedPreferences not initialized. Call init() first.");
    }
    await _prefs!.remove('currentUser');
  }

  Future<bool> register(User user) async {
    try {
      int userId = await _userRepository.createUser(user);
      if (userId > 0) {
        await _saveUserData(user);
        return true;
      }
    } catch (e) {
      print("Error during registration: $e");
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    try {
      User? user = await _userRepository.getUserByEmail(email);
      if (user != null && user.password == password) {
        await _saveUserData(user);
        return true;
      }
    } catch (e) {
      print("Error during login: $e");
    }
    return false;
  }

  Future<void> _saveUserData(User user) async {
    if (_prefs == null) {
      throw Exception("SharedPreferences not initialized. Call init() first.");
    }
    await _prefs!.setString('currentUser', jsonEncode(user.toJson()));
  }

  Future<bool> createUser(User user) async {
    try {
      int userId = await _userRepository.createUser(user);
      return userId > 0;
    } catch (e) {
      print("Error creating user: $e");
      return false;
    }
  }

  Future<List<User>> getAllUsers() async {
    return await _userRepository.getAllUsers();
  }

  Future<bool> updateUser(User user) async {
    try {
      await _userRepository.updateUser(user);
      return true;
    } catch (e) {
      print("Error updating user: $e");
      return false;
    }
  }

  Future<bool> deleteUser(int userId) async {
    try {
      await _userRepository.deleteUser(userId);
      return true;
    } catch (e) {
      print("Error deleting user: $e");
      return false;
    }
  }

  Future<User?> getProfile() async {
    await init(); // Ensure initialization
    return getCurrentUser();
  }

  Future<bool> updateProfile(User user) async {
    return updateUser(user);
  }
}
