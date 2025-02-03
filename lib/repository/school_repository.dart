import 'package:muzn/services/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:muzn/models/school_model.dart'; // Import your School model

class SchoolRepository {
  static final SchoolRepository _instance = SchoolRepository._internal();
  factory SchoolRepository() => _instance;
  SchoolRepository._internal();

  final DatabaseManager _databaseHelper = DatabaseManager();


  // Add a new school
  Future<int> addSchool(School school) async {
    final db = await _databaseHelper.database;
    return await db.insert('school', school.toJson());
  }

  // Get all schools
  Future<List<School>> getAllSchools() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('school');

    return maps.map((map) => School.fromJson(map)).toList();
  }
// Get schools by teacher ID
Future<List<School>> getSchoolsByTeacherId(int teacherId) async {
    final db = await _databaseHelper.database;
  final List<Map<String, dynamic>> maps = await db.query(
    'school',
    where: 'teacher_id = ?',
    whereArgs: [teacherId],
  );

  return maps.map((map) => School.fromJson(map)).toList();
}
  // Get a school by ID
  Future<School?> getSchoolById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'school',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return School.fromJson(maps.first);
    }
    return null;
  }

  // Update a school
  Future<int> updateSchool(School school) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'school',
      school.toJson(),
      where: 'id = ?',
      whereArgs: [school.id],
    );
  }

  // Delete a school
  Future<int> deleteSchool(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'school',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Soft delete a school (set deleted_at)
  Future<int> softDeleteSchool(int id) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'school',
      {'deleted_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}