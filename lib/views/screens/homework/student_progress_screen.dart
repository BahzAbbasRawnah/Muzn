import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/homework/homework_bloc.dart';
import 'package:muzn/blocs/homework/student_history_cubit.dart';
import 'package:muzn/models/circle.dart';
import 'package:muzn/models/student.dart';
import 'package:muzn/views/screens/homework/present_history_tab.dart';
import 'package:muzn/views/screens/homework/progress_following_tab.dart';
import 'package:muzn/views/screens/homework/progress_history_tab.dart';
import 'package:muzn/views/screens/homework/add_student_homework.dart';

class StudentProgressScreen extends StatefulWidget {
  final Student student;
  final Circle circle;

  const StudentProgressScreen({super.key,
    required this.student,
    required this.circle,
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
        .add(LoadHistoryEvent(context, widget.student.id));
    BlocProvider.of<HomeworkBloc>(context)
        .add(LoadHomeworkEvent(widget.student.id));

    // BlocProvider.of<HomeworkBloc>(context)
    //     .add(LoadHomeworkEvent(student.id));
  }


  @override
  Widget build(BuildContext context) {
    print('widget.student.uuid');
    print(widget.student.toMap().toString());
    return BlocListener<HomeworkBloc, HomeworkState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("student_homework".trans(context)),
            centerTitle: true,
            bottom: TabBar(
              onTap: (val) {
                print("val on tap ");
                print(val);
                if (val == 0) {
                  BlocProvider.of<HomeworkBloc>(context)
                      .add(LoadHomeworkEvent(widget.student.id));
                } else if(val==1){
                  BlocProvider.of<HomeworkBloc>(context)
                      .add(LoadHistoryEvent(context, widget.student.id));
                }else{
                  BlocProvider.of<StudentHistoryCubit>(context).loadStudentHistory(widget.circle.id!, widget.student.id);
                }
              },
              tabs: [
                Tab(child: Text("following_tab".trans(context))),
                Tab(child: Text("progress_tab".trans(context))),
                Tab(child: Text("history_tab".trans(context))),
              ],
            ),
          ),
          body: BlocBuilder<HomeworkBloc, HomeworkState>(
            builder: (context, state) {
              return Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            widget.student.user!.fullName,
                            style: Theme
                                .of(context)
                                .textTheme
                                .displayMedium,
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
                        ProgressFollowingTab(student: widget.student, circle: widget.circle,),
                        // Second Tab: Homework History
                        ProgressHistoryTab(studentId: widget.student.id),
                        PresentHistoryTab(student: widget.student),
                      ],
                    ),
                  ),
                ],
              );
            },
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
                  circleId: widget.circle.id!,
                  circleUuid: widget.circle.uuid!,
                  studentUuid: widget.student.uuid!,
                  onHomeworkAdded: () {
                    // Refresh the parent screen
                    BlocProvider.of<HomeworkBloc>(context).add(LoadHomeworkEvent(widget.student.id));
                  },
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     showModalBottomSheet(
          //       context: context,
          //       isScrollControlled: true,
          //       shape: const RoundedRectangleBorder(
          //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          //       ),
          //       builder: (context) =>
          //           AddHomeworkBottomSheet(
          //             studentId: widget.student.id,
          //             circleId: widget.circleId,
          //           ),
          //     );
          //   },
          //   child: const Icon(Icons.add),
          // ),
        ),
      ),
    );
  }
}
