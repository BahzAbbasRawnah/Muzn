import 'package:muzn/services/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class UserRepository {
DatabaseManager _databaseHelper=new DatabaseManager();

  // Insert a new user into the database
  Future<int> createUser(User user) async {
        final db = await _databaseHelper.database;

    return await db.insert(
      'User',
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all users from the database
  Future<List<User>> getAllUsers() async {
            final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query('User');
    return List.generate(maps.length, (index) {
      return User.fromJson(maps[index]);
    });
  }

  // Fetch a single user by ID
  Future<User?> getUserById(int id) async {
            final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'User',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  // Fetch a user by email (for login)
  Future<User?> getUserByEmail(String email) async {
            final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'User',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  // Update a user in the database
  Future<void> updateUser(User user) async {
            final db = await _databaseHelper.database;

    await db.update(
      'User',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Delete a user from the database
  Future<void> deleteUser(int id) async {
            final db = await _databaseHelper.database;

    await db.delete(
      'User',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Soft delete a user (set deleted_at timestamp)
  Future<void> softDeleteUser(int id) async {
            final db = await _databaseHelper.database;

    await db.update(
      'User',
      {'deleted_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}