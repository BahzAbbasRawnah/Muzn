import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/homework/homework_bloc.dart';
import 'package:muzn/models/homework.dart';
import 'package:muzn/views/screens/homework/progress_following_tab.dart';
import 'package:muzn/views/screens/homework/progress_history_tab.dart';
import 'package:muzn/views/screens/students/add_student_homework.dart';

class StudentProgressScreen extends StatefulWidget {
  final int studentId;
  final int circleId;

  const StudentProgressScreen({
    required this.studentId,
    required this.circleId,
  });

  @override
  State<StudentProgressScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentProgressScreen> {
  @override
  void initState() {
    super.initState();
    // Load homework when the screen is initialized
    _loadHomework();
  }

  void _loadHomework() {
    BlocProvider.of<HomeworkBloc>(context)
        .add(LoadHomeworkEvent(context, widget.studentId));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("student_homework".tr(context)),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(child: Text("following_tab".tr(context))),
              Tab(child: Text("progress_tab".tr(context))),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // First Tab: Current Homework
            ProgressFollowingTab(studentId: widget.studentId),
            // Second Tab: Homework History
            ProgressHistoryTab(studentId: widget.studentId),
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
                  studentId: widget.studentId, circleId: widget.circleId),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}