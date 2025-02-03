import 'package:muzn/models/circle_category_model.dart';
import 'package:muzn/services/database_service.dart';

class CirclesCategoryRepository {
  final DatabaseManager _databaseHelper = DatabaseManager();

  // Fetch all categories from the database
  Future<List<CirclesCategory>> fetchCategories() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('CirclesCategory');

    return List.generate(maps.length, (i) {
      return CirclesCategory.fromJson(maps[i]);
    });
  }

  // Fetch a single category by ID with error handling
  Future<CirclesCategory?> fetchCategoryById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'CirclesCategory',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return CirclesCategory.fromJson(maps.first);
    }
    return null; // Return null if not found
  }

  // Add a new category to the database
  Future<bool> addCategory(CirclesCategory category) async {
    final db = await _databaseHelper.database;
    int result = await db.insert('CirclesCategory', category.toJson());
    return result > 0;
  }

  // Update an existing category
  Future<bool> updateCategory(int id, CirclesCategory category) async {
    final db = await _databaseHelper.database;
    int result = await db.update(
      'CirclesCategory',
      category.toJson(),
      where: 'id = ?',
      whereArgs: [id],
    );
    return result > 0;
  }

  // Delete a category safely
  Future<bool> deleteCategory(int id) async {
    final db = await _databaseHelper.database;
    int result = await db.delete(
      'CirclesCategory',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result > 0;
  }
}
