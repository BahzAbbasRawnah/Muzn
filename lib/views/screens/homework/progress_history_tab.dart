import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/homework/homework_bloc.dart';
import 'package:muzn/models/homework.dart';
import 'package:muzn/views/widgets/empty_data.dart';
import 'package:muzn/views/screens/homework/history_item.dart';
import 'package:muzn/views/screens/homework/homework_item.dart';
import 'package:quran/quran.dart' as quran;

import '../../../blocs/auth/auth_bloc.dart';
import '../reports/report_body.dart';

class ProgressHistoryTab extends StatelessWidget {
  final int studentId;

  const ProgressHistoryTab({
    super.key,
    required this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    // Load history when this tab is built
    // BlocProvider.of<HomeworkBloc>(context)
    //     .add(LoadHistoryEvent(context, studentId));

    return BlocBuilder<HomeworkBloc, HomeworkState>(
      builder: (context, state) {
        if (state is HomeworkLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ProgressHistoryLoaded) {
          final ProgressHistoryItem = state.ProgressHistoryList.toList();
          if (ProgressHistoryItem.isEmpty) {
            return EmptyDataList();
          } else {
            return Column(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.print,
                  ),
                  onPressed: () {
                    if (BlocProvider.of<HomeworkBloc>(context)
                            .listStudentProgressHistory
                            ?.isNotEmpty ??
                        false) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Report(
                                    reportTitle:
                                        'history_report'.trans(context),
                                    startDateMiladi: '2023-10-01',
                                    endDateMiladi: '2023-10-31',
                                    startDateHijri: '1445-03-15',
                                    endDateHijri: '1445-04-15',
                                    headerTitles: [
                                      'من  ',

                                      'الى ',

                                      'التاريخ ',
                                      'اخطاء الحفظ ',
                                      'اخطاء التجويد ',
                                      'اخطاء التشكيل ',
                                      'الحفظ ',
                                      'المراجعة  ',
                                      'التلاوة  ',
                                    ],
                                    tableData:
                                        BlocProvider.of<HomeworkBloc>(context)
                                            .listStudentProgressHistory!
                                            .map((school) => [
                                                  // school.studentProgress.circleId.toString(),
                                                  '${quran.getSurahNameArabic(school
                                                          .homework
                                                          .startSurahNumber)} اية ${school.homework
                                                          .startAyahNumber}',
                                                  '${quran.getSurahNameArabic(
                                                      school.homework
                                                          .endSurahNumber)} اية ${school.homework
                                                          .endAyahNumber}',
                                                  school.homework.homeworkDate
                                                      .toIso8601String()
                                                      .split("T")[0],
                                                  school.studentProgress
                                                          .readingWrong
                                                          .toString() ??
                                                      'N/A',
                                                  school.studentProgress
                                                          .tajweedWrong
                                                          .toString() ??
                                                      'N/A',
                                                  school.studentProgress
                                                          .tashqeelWrong
                                                          .toString() ??
                                                      'N/A',
                                                  school.studentProgress
                                                      .readingRating.name
                                                      .trans(context),
                                                  school.studentProgress
                                                      .reviewRating.name
                                                      .trans(context),
                                                  school.studentProgress
                                                      .telawahRating.name
                                                      .trans(context),
                                                  // school.studentProgress.createdAt.toIso8601String().split('T')[0] ?? 'N/A'
                                                ])
                                            .toList(),
                                    // tableData: [
                                    //   ['Data 1', 'Data rrrrrrrrrrrrrrrrrrrrrrr2', 'Data 3', 'Data 4'],
                                    //   ['Data 4', 'Data 5', 'Data 6', 'Data 7'],
                                    // ],
                                    teacherName:
                                        BlocProvider.of<AuthBloc>(context)
                                                .userModel
                                                ?.fullName ??
                                            "",
                                    isShowAppBar: true,
                                  )));
                    }
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: ProgressHistoryItem.length,
                    itemBuilder: (context, index) {
                      final ProgressHistory = ProgressHistoryItem[index];
                      return HistoryItem(progressHistory: ProgressHistory);
                    },
                  ),
                ),
              ],
            );
          }
        } else if (state is HomeworkError) {
          return Center(child: Text(state.message));
        }
        if (BlocProvider.of<HomeworkBloc>(context)
                .listStudentProgressHistory
                ?.isNotEmpty ??
            false) {
          return ListView.builder(
            itemCount: BlocProvider.of<HomeworkBloc>(context)
                .listStudentProgressHistory
                ?.length,
            itemBuilder: (context, index) {
              final ProgressHistory = BlocProvider.of<HomeworkBloc>(context)
                  .listStudentProgressHistory![index];
              return HistoryItem(progressHistory: ProgressHistory);
            },
          );
        }
        return Container(); // Default case
      },
    );
  }
}
