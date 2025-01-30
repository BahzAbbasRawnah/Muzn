import 'package:equatable/equatable.dart';

abstract class SchoolState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SchoolInitial extends SchoolState {}

class SchoolLoading extends SchoolState {}

class SchoolLoaded extends SchoolState {
  final List<Map<String, dynamic>> schools;
  SchoolLoaded({required this.schools});
}

class SchoolError extends SchoolState {
  final String message;
  SchoolError({required this.message});
}

class SchoolAdded extends SchoolState {}

class SchoolEdited extends SchoolState {}

class SchoolDeleted extends SchoolState {}
