import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/bloc/StudentBloc/student_bloc.dart';
import 'package:muzn/bloc/StudentBloc/student_event.dart';
import 'package:muzn/bloc/StudentBloc/student_state.dart';
import 'package:muzn/views/screens/circle_student_bottomsheet.dart';
import 'package:muzn/views/screens/student_screen.dart';

class CircleScreen extends StatefulWidget {
  final int circleId;

  CircleScreen({required this.circleId});

  @override
  _CircleScreenState createState() => _CircleScreenState();
}

class _CircleScreenState extends State<CircleScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StudentBloc>().add(LoadStudents(widget.circleId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الحلقة ${widget.circleId}"), // Display circle name or ID
        centerTitle: true,
      ),
      body: BlocBuilder<StudentBloc, StudentState>(
        builder: (context, state) {
          if (state is StudentLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is StudentLoaded) {
            return ListView.builder(
              itemCount: state.students.length,
              itemBuilder: (context, index) {
                final student = state.students[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(student.user.fullName[0]),
                  ),
                  title: Text(student.user.fullName),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentScreen(),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is StudentError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return Container();
        },
      ),
    
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? isAdded = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            builder: (context) => AddStudentBottomSheet(),
          );
          if (isAdded == true) {
           
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
