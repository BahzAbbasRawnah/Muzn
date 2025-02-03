import 'package:muzn/models/circle_model.dart';
import 'package:muzn/services/database_service.dart';

class CircleRepository {
  final DatabaseManager _dbHelper = DatabaseManager();

  Future<int> addCircle(Circle circle) async {
    final db = await _dbHelper.database;
    return await db.insert('circle', circle.toJson());
  }

  Future<List<Circle>> getAllCircles() async {
    final db = await _dbHelper.database;
    final result = await db.query('circle');
    return result.map((json) => Circle.fromJson(json)).toList();
  }

  Future<List<Circle>> getCirclesBySchoolId(int schoolId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'circle',
      where: 'school_id = ?',
      whereArgs: [schoolId],
    );
    return result.map((json) => Circle.fromJson(json)).toList();
  }

  Future<Circle?> getCircleById(int id) async {
    final db = await _dbHelper.database;
    final result = await db.query('circle', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Circle.fromJson(result.first);
    }
    return null;
  }

  Future<int> updateCircle(Circle circle) async {
    final db = await _dbHelper.database;
    return await db.update(
      'circle',
      circle.toJson(),
      where: 'id = ?',
      whereArgs: [circle.id],
    );
  }

  Future<int> softDeleteCircle(int id) async {
    final db = await _dbHelper.database;
    return await db.update(
      'circle',
      {'deleted_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCircle(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('circle', where: 'id = ?', whereArgs: [id]);
  }
}
