
import 'package:equatable/equatable.dart';
import 'package:muzn/models/school_model.dart';

abstract class SchoolState extends Equatable {
  const SchoolState();

  @override
  List<Object> get props => [];
}

// Initial state
class SchoolInitial extends SchoolState {}

// Loading state
class SchoolLoading extends SchoolState {}

// State when a school is added
class SchoolAdded extends SchoolState {}

// State when schools are loaded
class SchoolsLoaded extends SchoolState {
  final List<School> schools;
  const SchoolsLoaded(this.schools);

  @override
  List<Object> get props => [schools];
}

// State when a single school is loaded
class SchoolLoaded extends SchoolState {
  final School school;
  const SchoolLoaded(this.school);

  @override
  List<Object> get props => [school];
}

// State when a school is updated
class SchoolUpdated extends SchoolState {}

// State when a school is deleted
class SchoolDeleted extends SchoolState {}

// State when a school is soft deleted
class SchoolSoftDeleted extends SchoolState {}

// Error state
class SchoolError extends SchoolState {
  final String message;
  const SchoolError(this.message);

  @override
  List<Object> get props => [message];
}