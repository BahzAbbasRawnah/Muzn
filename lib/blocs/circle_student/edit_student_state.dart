part of 'edit_student_cubit.dart';

@immutable
abstract class EditStudentState {}

class EditStudentInitial extends EditStudentState {}

class EditStudentLoading extends EditStudentState {}

class EditStudentSuccess extends EditStudentState {}

class EditStudentError extends EditStudentState {
  final String message;

  EditStudentError({required this.message});
}
