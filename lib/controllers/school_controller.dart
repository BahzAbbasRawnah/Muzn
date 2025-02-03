import 'package:muzn/models/school_model.dart';
import 'package:muzn/repository/school_repository.dart';

class SchoolController {
  final SchoolRepository _schoolRepository = SchoolRepository();
  // Add a new school
  Future<int> addSchool(School school) async {
    return await _schoolRepository.addSchool(school);
  }

  // Get all schools
  Future<List<School>> getAllSchools() async {
    return await _schoolRepository.getAllSchools();
  }
// Get schools by teacher ID
Future<List<School>> getSchoolsByTeacherId(int teacherId) async {
  return await _schoolRepository.getSchoolsByTeacherId(teacherId);
}
  // Get a school by ID
  Future<School?> getSchoolById(int id) async {
    return await _schoolRepository.getSchoolById(id);
  }

  // Update a school
  Future<int> updateSchool(School school) async {
    return await _schoolRepository.updateSchool(school);
  }

  // Delete a school
  Future<int> deleteSchool(int id) async {
    return await _schoolRepository.deleteSchool(id);
  }

  // Soft delete a school
  Future<int> softDeleteSchool(int id) async {
    return await _schoolRepository.softDeleteSchool(id);
  }
}