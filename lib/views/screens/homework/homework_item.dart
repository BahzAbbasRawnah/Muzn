import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/models/circle_student.dart';
import 'package:muzn/models/homework.dart';
import 'package:muzn/models/student.dart';
import 'package:muzn/views/screens/homework/edit_student_homework.dart';
import 'package:muzn/views/screens/students/rating_student.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:quran/quran.dart' as quran;
import 'package:jhijri/jHijri.dart';

import '../../../blocs/homework/homework_bloc.dart';

class HomeworksItem extends StatelessWidget {
  final Homework homework;
  final Student student;

  const HomeworksItem({
    super.key,
    required this.homework,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            /// 📌 **Column for Text Content**
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 📝 **Notes (Title)**
                Text(
                  homework.categoryName!,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Divider(color: Colors.black,),
                Row(
                  children: [
                    _buildItem(
                        context,
                        "from_surah".trans(context) +
                            quran
                                .getSurahNameArabic(homework.startSurahNumber)),
                    _buildItem(
                        context,
                        "to_surah".trans(context) +
                            quran.getSurahNameArabic(homework.endSurahNumber))
                  ],
                ),
                                const SizedBox(height: 10),

                Row(
                  children: [
                    _buildItem(
                        context,
                        "from_ayah".trans(context) +
                            homework.startAyahNumber.toString()),
                    _buildItem(
                        context,
                        "to_ayah".trans(context) +
                            homework.endAyahNumber.toString())
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 20, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            '${DateFormat('yyyy-MM-dd')
                                    .format(homework.homeworkDate)} مــ',
                            style: Theme.of(context).textTheme.displayMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 20, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            '${JHijri(fDate: homework.homeworkDate)} هــ ',
                            style: Theme.of(context).textTheme.displayMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Center(
                  child: CustomButton(
                    text: 'rating_button'.trans(context),
                    onPressed: () {
                      print("homework.toString()");
                      print(homework.toMap().toString());
                      print('student.toString()');
                      print(student.toMap().toString());
                      Get.off(RatingStudentScreen(
                                homework: homework,
                                student: student,
                        onHomeworkAdded: () {
                          // Refresh the parent screen
                          BlocProvider.of<HomeworkBloc>(context).add(LoadHomeworkEvent(student.id));
                        },
                              ));

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => RatingStudentScreen(
                      //       homework: homework,
                      //       student: student,
                      //     ),
                      //   ),
                      // );
                    },
                    icon: Icons.rate_review,
                  ),
                )
              ],
            ),

            /// ✏️ **Edit Button (Correctly Positioned)**
            Positioned(
              left: -5, // Moves the icon to the right side
              top: -5,
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => EditStudentHomeworkBottomSheet(homework: homework),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 **Helper Method to Create Rows with Two Text Widgets**
  Widget _buildItem(BuildContext context, String titleText) {
    return Expanded(
      child: Text(
        titleText,
        style: Theme.of(context).textTheme.displayMedium,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
