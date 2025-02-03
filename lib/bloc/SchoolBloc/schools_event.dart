
import 'package:equatable/equatable.dart';
import 'package:muzn/models/school_model.dart';

abstract class SchoolEvent extends Equatable {
  const SchoolEvent();

  @override
  List<Object> get props => [];
}

// Event to add a new school
class AddSchoolEvent extends SchoolEvent {
  final School school;
  const AddSchoolEvent(this.school);

  @override
  List<Object> get props => [school];
}

// Event to get all schools
class GetAllSchoolsEvent extends SchoolEvent {}

// Event to get a school by ID
class GetSchoolByIdEvent extends SchoolEvent {
  final int id;
  const GetSchoolByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}
// Event to fetch schools by teacher ID
class GetSchoolsByTeacherIdEvent extends SchoolEvent {
  final int teacherId;
  const GetSchoolsByTeacherIdEvent(this.teacherId);

  @override
  List<Object> get props => [teacherId];
}
// Event to update a school
class UpdateSchoolEvent extends SchoolEvent {
  final School school;
  const UpdateSchoolEvent(this.school);

  @override
  List<Object> get props => [school];
}

// Event to delete a school
class DeleteSchoolEvent extends SchoolEvent {
  final int id;
  const DeleteSchoolEvent(this.id);

  @override
  List<Object> get props => [id];
}

// Event to soft delete a school
class SoftDeleteSchoolEvent extends SchoolEvent {
  final int id;
  const SoftDeleteSchoolEvent(this.id);

  @override
  List<Object> get props => [id];
}