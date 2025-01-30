import 'package:muzn/models/circle_category_model.dart';
import 'package:muzn/services/local_database.dart';
import 'package:muzn/utils/request_status.dart';

class CircleController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // ================== Circle Operations ==================

  /// Add a new circle

  Future<RequestStatus> addSchoolMosque(
      Map<String, dynamic> schoolMosque) async {
    try {
      int result = await _databaseHelper.insertSchoolMosque(schoolMosque);
      if (result > 0) {
        return RequestStatus.success("School Added successfully!");
      } else {
        return RequestStatus.failure("School Added failed!");
      }
    } catch (e) {
      print("Error: $e");
      return RequestStatus.failure("Error: $e");
    }
  }

  Future<RequestStatus> addCircle(Map<String, dynamic> circle) async {
    int result = await _databaseHelper.insertCircle(circle);
    try {
      if (result > 0) {
        return RequestStatus.success("Circle Added successfully!");
      } else {
        return RequestStatus.failure("Circle Added failed!");
      }
    } catch (e) {
      print("Error: $e");
      return RequestStatus.failure("Error: $e");
    }
  }

  /// Fetch a circle by its ID
  Future<Map<String, dynamic>?> fetchCircleById(int id) async {
    if (id <= 0) {
      throw Exception("Invalid Circle ID");
    }
    return await _databaseHelper.getCircleById(id);
  }

  /// Fetch all circles
  Future<List<Map<String, dynamic>>> fetchAllCircles() async {
    return await _databaseHelper.getAllCircles();
  }

  /// Fetch all circles of a specific mosque/school
  Future<List<Map<String, dynamic>>> fetchMosqueCircles(int schoolId) async {
   
    return await _databaseHelper.getAllMosqueCircles(schoolId);
  }

  /// Update an existing circle
  Future<int> editCircle(Map<String, dynamic> circle) async {
    if (circle.isEmpty || !circle.containsKey('id')) {
      throw Exception("Invalid data for updating Circle");
    }
    return await _databaseHelper.updateCircle(circle);
  }

  /// Delete a circle by its ID
  Future<int> removeCircle(int id) async {
    if (id <= 0) {
      throw Exception("Invalid Circle ID");
    }
    return await _databaseHelper.deleteCircle(id);
  }

  // ================== Circle Category Operations ==================

  /// Add a new circle category
  Future<int> addCircleCategory(Map<String, dynamic> category) async {
    if (category.isEmpty) {
      throw Exception("Category data cannot be empty");
    }
    return await _databaseHelper.insertCirclesCategory(category);
  }

  /// Fetch a circle category by its ID
  Future<Map<String, dynamic>?> fetchCircleCategoryById(int id) async {
    if (id <= 0) {
      throw Exception("Invalid Category ID");
    }
    return await _databaseHelper.getCirclesCategoryById(id);
  }

  /// Fetch all circle categories
  Future<List<CirclesCategory>> fetchAllCircleCategories() async {
    final List<Map<String, dynamic>> categoriesData =
        await _databaseHelper.getAllCirclesCategories();

    return categoriesData
        .map((category) => CirclesCategory.fromMap(category))
        .toList();
  }

  /// Update a circle category
  Future<int> editCircleCategory(Map<String, dynamic> category) async {
    if (category.isEmpty || !category.containsKey('id')) {
      throw Exception("Invalid data for updating Category");
    }
    return await _databaseHelper.updateCirclesCategory(category);
  }

  /// Delete a circle category by its ID
  Future<int> removeCircleCategory(int id) async {
    if (id <= 0) {
      throw Exception("Invalid Category ID");
    }
    return await _databaseHelper.deleteCirclesCategory(id);
  }
}
