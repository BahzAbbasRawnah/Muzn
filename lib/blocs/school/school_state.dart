part of 'school_cubit.dart';

abstract class SchoolState extends Equatable {
  @override
  List<Object> get props => [];
}

class SchoolInitial extends SchoolState {}

class SchoolLoading extends SchoolState {}

class SchoolUpdated extends SchoolState {}

class SchoolsLoaded extends SchoolState {
  final List<School> schools;
  SchoolsLoaded(this.schools);

  @override
  List<Object> get props => [schools];
}

class SchoolError extends SchoolState {
  final String message;
  SchoolError(this.message);

  @override
  List<Object> get props => [message];
}
