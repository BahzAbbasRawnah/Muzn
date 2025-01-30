import 'package:equatable/equatable.dart';

abstract class SchoolEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSchools extends SchoolEvent {
  final int teacherId;
  LoadSchools({required this.teacherId});
}

class AddSchoolEvent extends SchoolEvent {
  final Map<String, dynamic> school;
  AddSchoolEvent({required this.school});
}

class EditSchoolEvent extends SchoolEvent {
  final int schoolId;
  final Map<String, dynamic> updatedData;
  EditSchoolEvent({required this.schoolId, required this.updatedData});
}

class DeleteSchoolEvent extends SchoolEvent {
  final int schoolId;
  DeleteSchoolEvent({required this.schoolId});
}
