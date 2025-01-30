import 'package:muzn/controllers/circle_controller.dart';
import 'package:muzn/utils/request_status.dart';

class CircleRepository {
  final CircleController _circleController = CircleController();

  Future<List<Map<String, dynamic>>> fetchMosqueCircles(int schoolId) async {
    return await _circleController.fetchMosqueCircles(schoolId);
  }
  Future<List<Map<String, dynamic>>> fetchCircles(int teacherId) async {
    return await _circleController.fetchAllCircles();
  }

  Future<void> addCircle(Map<String, dynamic> circle) async {
    RequestStatus result = await _circleController.addCircle(circle);
    if (result.status == true) {

    }
  }

  Future<void> editCircle(
      int circleId, Map<String, dynamic> updatedData) async {
    // Implement edit circle logic
  }

  Future<void> deleteCircle(int circleId) async {
    // Implement delete circle logic
  }
}
