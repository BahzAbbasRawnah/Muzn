import 'package:muzn/services/local_database.dart';

class StudentProgressController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // ================== StudentProgress Operations ==================

  /// Add a new student progress
  Future<int> addStudentProgress(Map<String, dynamic> progress) async {
    if (progress.isEmpty) {
      throw Exception("Progress data cannot be empty");
    }
    return await _databaseHelper.insertStudentProgress(progress);
  }

  /// Fetch a student progress by ID
  Future<Map<String, dynamic>?> fetchStudentProgressById(int id) async {
    if (id <= 0) {
      throw Exception("Invalid StudentProgress ID");
    }
    return await _databaseHelper.getStudentProgressById(id);
  }

  /// Fetch all student progress records
  Future<List<Map<String, dynamic>>> fetchAllStudentProgress() async {
    return await _databaseHelper.getAllStudentProgress();
  }

  /// Update a student progress
  Future<int> editStudentProgress(Map<String, dynamic> progress) async {
    if (progress.isEmpty || !progress.containsKey('id')) {
      throw Exception("Invalid data for updating StudentProgress");
    }
    return await _databaseHelper.updateStudentProgress(progress);
  }

  /// Delete a student progress by ID
  Future<int> removeStudentProgress(int id) async {
    if (id <= 0) {
      throw Exception("Invalid StudentProgress ID");
    }
    return await _databaseHelper.deleteStudentProgress(id);
  }

  // ================== HomeWork Operations ==================

  /// Add a new homework
  Future<int> addHomeWork(Map<String, dynamic> homework) async {
    if (homework.isEmpty) {
      throw Exception("Assignment data cannot be empty");
    }
    return await _databaseHelper.insertHomeWork(homework);
  }

  /// Fetch an homework by ID
  Future<Map<String, dynamic>?> fetchHomeWorkById(int id) async {
    if (id <= 0) {
      throw Exception("Invalid HomeWork ID");
    }
    return await _databaseHelper.getHomeWorkById(id);
  }

  /// Fetch all homeworks
  Future<List<Map<String, dynamic>>> fetchAllHomeWorks() async {
    return await _databaseHelper.getAllHomeWorks();
  }

  /// Update an homework
  Future<int> editHomeWork(Map<String, dynamic> homework) async {
    if (homework.isEmpty || !homework.containsKey('id')) {
      throw Exception("Invalid data for updating HomeWork");
    }
    return await _databaseHelper.updateHomeWork(homework);
  }

  /// Delete an homework by ID
  Future<int> removeHomeWork(int id) async {
    if (id <= 0) {
      throw Exception("Invalid HomeWork ID");
    }
    return await _databaseHelper.deleteHomeWork(id);
  }
}
