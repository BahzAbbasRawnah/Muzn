import 'package:equatable/equatable.dart';
import 'package:muzn/models/student_model.dart';

abstract class StudentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadStudents extends StudentEvent {
  final int circleId;
  
  LoadStudents(this.circleId);

  @override
  List<Object?> get props => [circleId];
}

class AddStudent extends StudentEvent {
  final Student student;
  
  AddStudent(this.student);

  @override
  List<Object?> get props => [student];
}

class EditStudent extends StudentEvent {
  final Student student;
  
  EditStudent(this.student);

  @override
  List<Object?> get props => [student];
}

class DeleteStudent extends StudentEvent {
  final int id;
  
  DeleteStudent(this.id);

  @override
  List<Object?> get props => [id];
}
