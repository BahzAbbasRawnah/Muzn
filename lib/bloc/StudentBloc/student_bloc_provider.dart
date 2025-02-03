// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:muzn/bloc/StudentBloc/student_event.dart';
// import 'student_bloc.dart';
// import 'package:muzn/controllers/student_controller.dart';

// class StudentBlocProvider extends StatelessWidget {
//   final Widget child;
//   final int circleId;

//   const StudentBlocProvider({Key? key, required this.child, required this.circleId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => StudentBloc(StudentController())..add(LoadStudents(circleId)),
//       child: child,
//     );
//   }
// }
