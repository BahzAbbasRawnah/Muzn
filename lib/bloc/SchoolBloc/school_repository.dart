import 'package:muzn/controllers/school_controller.dart';
import 'package:muzn/utils/request_status.dart';

class SchoolRepository {
  final SchoolController _schoolController = SchoolController();

  Future<List<Map<String, dynamic>>> fetchSchools(int teacherId) async {
    return await _schoolController.fetchListSchoolMosques(teacherId);
  }

  Future<void> addSchool(Map<String, dynamic> school) async {
    RequestStatus result = await _schoolController.addSchoolMosque(school);
    if (result.status == true) {

    }
  }

  Future<void> editSchool(
      int schoolId, Map<String, dynamic> updatedData) async {
    // Implement edit school logic
  }

  Future<void> deleteSchool(int schoolId) async {
    // Implement delete school logic
  }
}
