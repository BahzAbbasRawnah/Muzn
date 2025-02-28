import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/homework/homework_bloc.dart';
import 'package:muzn/models/student.dart';
import 'package:muzn/views/screens/homework/progress_following_tab.dart';
import 'package:muzn/views/screens/homework/progress_history_tab.dart';
import 'package:muzn/views/screens/homework/add_student_homework.dart';

class StudentProgressScreen extends StatefulWidget {
  final Student student;
  final int circleId;

  const StudentProgressScreen({
    required this.student,
    required this.circleId,
  });

  @override
  State<StudentProgressScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentProgressScreen> {

  @override
  void initState() {
    super.initState();
    // Load homework and student name when the screen is initialized
    _loadHomework();
  }

  void _loadHomework() {
    BlocProvider.of<HomeworkBloc>(context)
        .add(LoadHomeworkEvent(context, widget.student.id));
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("student_homework".trans(context)),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(child: Text("following_tab".trans(context))),
              Tab(child: Text("progress_tab".trans(context))),
            ],
          ),
        ),
        body: Column(
          children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[ 
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                     widget.student.user!.fullName,
                    style: Theme.of(context).textTheme.displayMedium,
                                    ),
                  ),
                ]
              ),
            Divider(),
            // TabBarView for the tabs
            Expanded(
              child: TabBarView(
                children: [
                  // First Tab: Current Homework
                  ProgressFollowingTab(student: widget.student),
                  // Second Tab: Homework History
                  ProgressHistoryTab(studentId: widget.student.id),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => AddHomeworkBottomSheet(
                studentId: widget.student.id,
                circleId: widget.circleId,
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
