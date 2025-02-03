import 'package:muzn/models/circle_model.dart';
import 'package:muzn/repository/circle_repository.dart';

class CircleController {
  final CircleRepository _circleRepository = CircleRepository();

  Future<int> addCircle(Circle circle) {
    print('circle data: ' +circle.toString());
    return _circleRepository.addCircle(circle);
  }

  Future<List<Circle>> getAllCircles() => _circleRepository.getAllCircles();
  Future<List<Circle>> getCirclesBySchoolId(int schoolId) =>
      _circleRepository.getCirclesBySchoolId(schoolId);
  Future<Circle?> getCircleById(int id) => _circleRepository.getCircleById(id);
  Future<int> updateCircle(Circle circle) =>
      _circleRepository.updateCircle(circle);
  Future<int> softDeleteCircle(int id) =>
      _circleRepository.softDeleteCircle(id);
  Future<int> deleteCircle(int id) => _circleRepository.deleteCircle(id);
}
