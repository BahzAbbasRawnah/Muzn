// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:muzn/bloc/CircleBloc/circle_bloc.dart';
// import 'package:muzn/bloc/StudentBloc/student_bloc.dart';
// import 'package:muzn/bloc/StudentBloc/student_event.dart';
// import 'package:muzn/bloc/StudentBloc/student_state.dart';
// import 'package:muzn/views/screens/circle_student_bottomsheet.dart';
// import 'package:muzn/views/screens/student_screen.dart';

// class CircleScreen extends StatefulWidget {
//   final int circleId;

//   const CircleScreen({Key? key, required this.circleId}) : super(key: key);

//   @override
//   _CircleScreenState createState() => _CircleScreenState();
// }

// class _CircleScreenState extends State<CircleScreen> {
//   late StudentBloc _studentBloc;

//   @override
//   void initState() {
//     super.initState();
//     _studentBloc = context.read<StudentBloc>();
//     _studentBloc.add(LoadStudents(widget.circleId));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("الحلقة ${widget.circleId}"), // Display circle name or ID
//         centerTitle: true,
//       ),
//      body: BlocBuilder<StudentBloc, StudentState>(
//   builder: (context, state) {
//     if (state is StudentLoading) {
//       return const Center(child: CircularProgressIndicator());
//     } else if (state is StudentLoaded) {
//       return ListView.builder(
//         itemCount: state.students.length,
//         itemBuilder: (context, index) {
//           final student = state.students[index];
//           return ListTile(
//             key: ValueKey(student.id), // Use student_id from data
//             leading: CircleAvatar(
//               child: Text(student.user.fullName.isNotEmpty 
//                   ? student.user.fullName[0] 
//                   : '?'), // Ensure no empty names cause errors
//             ),
//             title: Text(student.user.email),
//             subtitle: Text("${student.user.phone} | ${student.user.country}"),
//             onTap: () {
//               // Handle student tap if needed
//             },
//           );
//         },
//       );
//     } else if (state is StudentError) {
//       return Center(child: Text("Error: ${state.message}"));
//     }
//     return const SizedBox.shrink();
//   },

//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           bool? isAdded = await showModalBottomSheet<bool>(
//             context: context,
//             isScrollControlled: true,
//             builder: (context) => AddStudentBottomSheet(circleID: widget.circleId),
//           );
//           if (isAdded == true) {
//             _studentBloc.add(LoadStudents(widget.circleId));
//           }
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
