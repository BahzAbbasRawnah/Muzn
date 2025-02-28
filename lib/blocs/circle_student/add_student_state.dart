part of 'add_student_cubit.dart';

@immutable
abstract class AddStudentState {}

class AddStudentInitial extends AddStudentState {}

class AddStudentLoading extends AddStudentState {}

class AddStudentSuccess extends AddStudentState {}

class AddStudentError extends AddStudentState {
  final String message;

  AddStudentError(this.message);
}
