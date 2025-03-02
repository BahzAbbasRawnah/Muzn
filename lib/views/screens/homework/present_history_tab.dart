import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/homework/homework_bloc.dart';
import 'package:muzn/models/circle_student.dart';
import 'package:muzn/models/student.dart';
import 'package:muzn/views/widgets/empty_data.dart';
import 'package:muzn/views/screens/homework/homework_item.dart';
import 'package:muzn/models/homework.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/homework/student_history_cubit.dart';
import '../../../blocs/homework/student_history_state.dart';
import '../../../models/enums.dart';
import '../reports/report_body.dart';

class PresentHistoryTab extends StatelessWidget {
  final Student student;

  const PresentHistoryTab({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    // Load homework when this tab is built
    // BlocProvider.of<HomeworkBloc>(context)
    //     .add(LoadHomeworkEvent(student.id));
     return

      //  BlocProvider(
      // create: (context) => StudentHistoryCubit(),
      // child:
      BlocBuilder<StudentHistoryCubit, StudentHistoryState>(
        builder: (context, state) {
          if (state is StudentHistoryLoading) {
            return CircularProgressIndicator();
          } else if (state is StudentHistoryLoaded) {
        return     Report(
              reportTitle: 'student_report'.trans(context),
              startDateMiladi: '2023-10-01',
              endDateMiladi: '2023-10-31',
              startDateHijri: '1445-03-15',
              endDateHijri: '1445-04-15',
              headerTitles: [
                'التاريخ',
                'الحالة',

              ],
              tableData:  state.attendanceHistory.map((school) =>
              [
                school.attendanceDate.toIso8601String().split('T')[0],
                school.status.name.trans(context).toString() ?? 'N/A',

                // school.circleId.toString() ?? 'N/A',
                // school.createdAt?.toIso8601String().split('T')[0] ?? 'N/A'
              ])
                  .toList(),
              // tableData: [
              //   ['Data 1', 'Data rrrrrrrrrrrrrrrrrrrrrrr2', 'Data 3', 'Data 4'],
              //   ['Data 4', 'Data 5', 'Data 6', 'Data 7'],
              // ],
              teacherName: BlocProvider.of<AuthBloc>(context).userModel?.fullName ?? "",
            );
            return ListView(
              children: state.attendanceHistory.map((record) {
                return ListTile(
                  title: Container(

                    decoration: BoxDecoration(
                    color: _getStatusColor(record.status),
                borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          (
                              record.status.name == 'none')
                              ? 'attendance'.trans(context)
                              : record.status.name.trans(context),
                          style: const TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 10,),
                        Text(
                          record.attendanceDate.toIso8601String().split("T")[0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  // subtitle: Text(record.attendanceDate.toString()),
                  // Text(
                  //   "Date: ${record.attendanceDate.toLocal()} - Status: ${record.status.name}",
                  // style: TextStyle(color: Colors.black),),
                );
              }).toList(),
            );
          } else if (state is StudentHistoryError) {
            return Text("Error: ${state.error}");
          }
          return SizedBox.shrink();
        },
      );
    // );

    // return BlocBuilder<HomeworkBloc, HomeworkState>(
    //   builder: (context, state) {
    //     print('home work state');
    //     print(state.toString());
    //     if (state is HomeworkLoading) {
    //       return Center(child: CircularProgressIndicator());
    //     }
    //     if(BlocProvider.of<HomeworkBloc>(context).listHomeWork?.isNotEmpty??false){
    //       return ListView.builder(
    //         itemCount: BlocProvider.of<HomeworkBloc>(context).listHomeWork?.length,
    //         itemBuilder: (context, index) {
    //           final homework = BlocProvider.of<HomeworkBloc>(context).listHomeWork![index];
    //           return HomeworksItem(homework: homework, student: student);
    //         },
    //       );
    //     }
    //     else if (state is HomeworkLoaded) {
    //       final homeworkItems = state.homeworkList;
    //       if (homeworkItems.isEmpty) {
    //         return EmptyDataList();
    //       }
    //       return ListView.builder(
    //         itemCount: homeworkItems.length,
    //         itemBuilder: (context, index) {
    //           final homework = homeworkItems[index];
    //           return HomeworksItem(homework: homework, student: student);
    //         },
    //       );
    //     }
    //     else if (state is HomeworkError) {
    //       return Center(child: Text(state.message));
    //     }
    //     return Container(); // Default case
    //   },
    // );
  }
  Color _getStatusColor(AttendanceStatuse? status) {
    switch (status) {
      case AttendanceStatuse.present:
        return Colors.green;
      case AttendanceStatuse.absent:
        return Colors.red;
      case AttendanceStatuse.absent_with_excuse:
        return Colors.orange;
      case AttendanceStatuse.early_departure:
        return Colors.amber;
      case AttendanceStatuse.not_listened:
        return Colors.grey;
      case AttendanceStatuse.late:
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

}
