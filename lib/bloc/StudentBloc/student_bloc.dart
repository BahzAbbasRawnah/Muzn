// // student_bloc.dart
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:muzn/controllers/student_controller.dart';
// import 'student_event.dart';
// import 'student_state.dart';
// import 'package:muzn/models/student_model.dart';

// class StudentBloc extends Bloc<StudentEvent, StudentState> {
//   final StudentController studentController;
//   StudentBloc(this.studentController) : super(StudentInitial()) {
//     on<LoadStudents>(_onLoadStudents);
//     on<AddStudent>(_onAddStudent);
//     on<EditStudent>(_onEditStudent);
//     on<DeleteStudent>(_onDeleteStudent);
//   }

//   Future<void> _onLoadStudents(
//       LoadStudents event, Emitter<StudentState> emit) async {
//     emit(StudentLoading());
//     try {
//       final circleData =
//           await studentController.fetchCircleWithStudentById(event.circleId);
//       print("Circle data: " + circleData.toString());
//       if (circleData == null) {
//         emit(StudentError("No data found for this circle."));
//         return;
//       }

//       final students = (circleData['students'] as List)
//           .map((student) => Student.fromMap(student))
//           .toList();

//       emit(StudentLoaded(students));
//     } catch (e) {
//       emit(StudentError(e.toString()));
//     }
//   }

//   Future<void> _onAddStudent(
//       AddStudent event, Emitter<StudentState> emit) async {
//     try {
//       await studentController.addStudent(event.student, event.circleId);
//       add(LoadStudents(event.circleId));
//     } catch (e) {
//       emit(StudentError(e.toString()));
//     }
//   }

//   Future<void> _onEditStudent(
//       EditStudent event, Emitter<StudentState> emit) async {
//     try {
//       await studentController.editStudent(event.student.toMap());
//       add(LoadStudents(1));
//     } catch (e) {
//       emit(StudentError(e.toString()));
//     }
//   }

//   Future<void> _onDeleteStudent(
//       DeleteStudent event, Emitter<StudentState> emit) async {
//     try {
//       await studentController.removeStudent(event.id);
//       add(LoadStudents(1));
//     } catch (e) {
//       emit(StudentError(e.toString()));
//     }
//   }
// }
