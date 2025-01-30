import 'package:muzn/models/school_model.dart';
import 'package:muzn/services/local_database.dart';
import 'package:muzn/utils/request_status.dart';

class SchoolController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  /// Insert a new school/mosque
  Future<RequestStatus> addSchoolMosque(
      Map<String, dynamic> schoolMosque) async {
    try {
      int result = await _databaseHelper.insertSchoolMosque(schoolMosque);
      if (result > 0) {
        return RequestStatus.success(
          "School Added successfully!"
        );
      } else {
        return RequestStatus.failure("School Added failed!");
      }
    } catch (e) {
      print("Error: $e");
      return RequestStatus.failure("Error: $e");
    }
  }

  /// Fetch a single school/mosque by ID
  Future<Map<String, dynamic>?> fetchSchoolMosqueById(int id) async {
    if (id <= 0) {
      throw Exception("Invalid School/Mosque ID");
    }
    return await _databaseHelper.getSchoolMosqueById(id);
  }

  // / Fetch all schools/mosques
  Future<List<Map<String, dynamic>>> fetchListSchoolMosques(
      int teacherId) async {
    return await _databaseHelper.getAllSchoolMosquesWithCirclesCount(teacherId);
  }
Future<List<SchoolMosque>> fetchAllSchoolMosques(int teacherId) async {
  try {
    final List<Map<String, dynamic>> schoolMaps =
        await _databaseHelper.getAllSchoolMosquesWithCirclesCount(teacherId);
    
    return schoolMaps.map((map) => SchoolMosque.fromMap(map)).toList();
  } catch (e) {
    print("Error fetching schools/mosques: $e");
    return [];
  }
}


  /// Update an existing school/mosque
  Future<int> editSchoolMosque(Map<String, dynamic> schoolMosque, Map<String, String> map) async {
    if (schoolMosque.isEmpty || !schoolMosque.containsKey('id')) {
      throw Exception("Invalid data for updating School/Mosque");
    }
    return await _databaseHelper.updateSchoolMosque(schoolMosque);
  }

  /// Delete a school/mosque by ID
  Future<int> removeSchoolMosque(int id) async {
    if (id <= 0) {
      throw Exception("Invalid School/Mosque ID");
    }
    return await _databaseHelper.deleteSchoolMosque(id);
  }

  /// Search schools/mosques by name
  // Future<List<Map<String, dynamic>>> searchSchoolsByName(String name) async {
  //   if (name.isEmpty) {
  //     throw Exception("Search term cannot be empty");
  //   }
  //   return await _databaseHelper.searchSchoolMosquesByName(name);
  // }

  // /// Count all schools/mosques
  // Future<int> countAllSchools() async {
  //   return await _databaseHelper.countAllSchoolMosques();
  // }
}
