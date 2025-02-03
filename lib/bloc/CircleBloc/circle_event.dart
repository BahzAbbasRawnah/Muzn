import 'package:equatable/equatable.dart';
import 'package:muzn/models/circle_model.dart';

abstract class CircleEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Create a new circle
class AddCircleEvent extends CircleEvent {
  final Circle circle;
  AddCircleEvent(this.circle);
  @override
  List<Object> get props => [circle];
}

// Fetch all circles
class GetAllCirclesEvent extends CircleEvent {}

// Fetch circles by school ID
class GetCirclesBySchoolIdEvent extends CircleEvent {
  final int schoolId;
  GetCirclesBySchoolIdEvent(this.schoolId);
  @override
  List<Object> get props => [schoolId];
}

// Fetch a single circle by ID
class GetCircleByIdEvent extends CircleEvent {
  final int id;
  GetCircleByIdEvent(this.id);
  @override
  List<Object> get props => [id];
}

// Update a circle
class UpdateCircleEvent extends CircleEvent {
  final Circle circle;
  UpdateCircleEvent(this.circle);
  @override
  List<Object> get props => [circle];
}

// Soft delete a circle
class SoftDeleteCircleEvent extends CircleEvent {
  final int id;
  final int schoolId; // Needed to refresh list after delete
  SoftDeleteCircleEvent(this.id, this.schoolId);
  @override
  List<Object> get props => [id, schoolId];
}

// Permanently delete a circle
class DeleteCircleEvent extends CircleEvent {
  final int id;
  final int schoolId; // Needed to refresh list after delete
  DeleteCircleEvent(this.id, this.schoolId);
  @override
  List<Object> get props => [id, schoolId];
}

// Fetch categories
class GetCategoriesEvent extends CircleEvent {}

// Fetch schools
class GetSchoolsEvent extends CircleEvent {}