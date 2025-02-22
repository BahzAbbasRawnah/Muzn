import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jhijri/_src/_jHijri.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/student/student_progress_bloc.dart';
import 'package:muzn/models/circle_student.dart';
import 'package:muzn/models/enums.dart';
import 'package:muzn/models/homework.dart';
import 'package:muzn/models/student.dart';
import 'package:muzn/models/student_progress.dart'; // Import the StudentProgress model
import 'package:muzn/views/screens/homework/student_progress_screen.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_quantity_input.dart';
import 'package:muzn/views/widgets/rateing_selector.dart';
import 'package:quran/quran.dart' as quran;
import 'package:flutter_bloc/flutter_bloc.dart';

class RatingStudentScreen extends StatefulWidget {
  final Homework homework;
  final Student student;

  const RatingStudentScreen({
    Key? key,
    required this.homework,
    required this.student,
  }) : super(key: key);

  @override
  State<RatingStudentScreen> createState() => _RatingStudentScreenState();
}

class _RatingStudentScreenState extends State<RatingStudentScreen> {
  int readingWrongs = 0;
  int tajweedWrongs = 0;
  int tashkeelWrongs = 0;

  @override
  Widget build(BuildContext context) {
    Rating _readingRating=Rating.good;
    Rating _reviewRating=Rating.good;
    Rating _telawahRating=Rating.good;

    return Scaffold(
      appBar: AppBar(
        title: Text("student_rating".tr(context)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      widget.homework.categoryName!,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Divider(color: Colors.black),
                  // Surah Information
                  Row(
                    children: [
                      _buildItem(
                        context,
                        "from_surah".tr(context) +
                            quran.getSurahNameArabic(
                                widget.homework.startSurahNumber),
                      ),
                      _buildItem(
                        context,
                        "to_surah".tr(context) +
                            quran.getSurahNameArabic(
                                widget.homework.endSurahNumber),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Ayah Information
                  Row(
                    children: [
                      _buildItem(
                        context,
                        "from_ayah".tr(context) +
                            widget.homework.startAyahNumber.toString(),
                      ),
                      _buildItem(
                        context,
                        "to_ayah".tr(context) +
                            widget.homework.endAyahNumber.toString(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Date Information
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 20, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('yyyy-MM-dd')
                                      .format(widget.homework.homeworkDate) +
                                  ' مــ',
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 20, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              JHijri(fDate: widget.homework.homeworkDate)
                                      .toString() +
                                  ' هــ ',
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'student_score'.tr(context),
                      style: Theme.of(context).textTheme.displayLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Column(
                    children: [
                      QuantityInput(
                        label: "reading_wrongs".tr(context),
                        onQuantityChanged: (value) {
                          setState(() => readingWrongs = value);
                        },
                      ),
                      QuantityInput(
                        label: "tajweed_wrongs".tr(context),
                        onQuantityChanged: (value) {
                          setState(() => tajweedWrongs = value);
                        },
                      ),
                      QuantityInput(
                        label: "tashkeel_wrongs".tr(context),
                        onQuantityChanged: (value) {
                          setState(() => tashkeelWrongs = value);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'student_rating'.tr(context),
                      style: Theme.of(context).textTheme.displayLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                 const SizedBox(height: 10),

                  // Rating Selector
                  Text(
                      'reading_rating'.tr(context),
                      style: Theme.of(context).textTheme.displayMedium,

                 
                    ),
               const SizedBox(height: 10),

                  RatingSelector(
                    initialRating: Rating.good,
                    onChanged: (rating) {
                      _readingRating = rating!;
                    },
                  ),

                   const SizedBox(height: 10),

                  // Rating Selector
                  Text(
                      'review_rating'.tr(context),
                      style: Theme.of(context).textTheme.displayMedium,

                 
                    ),
               const SizedBox(height: 10),

                  RatingSelector(
                    initialRating: Rating.good,
                    onChanged: (rating) {
                      _reviewRating = rating!;
                    },
                  ),
                   const SizedBox(height: 10),

                  // Rating Selector
                  Text(
                      'telawah_rating'.tr(context),
                      style: Theme.of(context).textTheme.displayMedium,

                 
                    ),
               const SizedBox(height: 10),

                  RatingSelector(
                    initialRating: Rating.good,
                    onChanged: (rating) {
                      _telawahRating = rating!;
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: CustomButton(
                      text: 'save'.tr(context),
                      icon: Icons.save,
                      onPressed: () {
                        StudentProgress progress = new StudentProgress(
                            id: 0,
                            circleId: widget.homework.circleId,
                            studentId: widget.homework.studentId,
                            homeworkId: widget.homework.id,
                            readingRating:_readingRating,
                            reviewRating: _reviewRating,
                            telawahRating: _telawahRating,
                            readingWrong: readingWrongs,
                            tajweedWrong: tajweedWrongs,
                            tashqeelWrong: tashkeelWrongs,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now()
                            );
                        _saveProgress(context,progress);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveProgress(BuildContext context,StudentProgress studentProgress) {
    // Create an instance of StudentProgress


    context.read<StudentProgressBloc>().setStudentProgress(studentProgress);

    // Dispatch the event
    context.read<StudentProgressBloc>().add(AddStudentProgress(
          studentProgress: studentProgress,
        ));
    context.read<StudentProgressBloc>().stream.listen((state) {
      if (state is StudentProgressAdded) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StudentProgressScreen(
              student: widget.student,
              circleId: studentProgress.circleId,
            ),
          ),
        );
      } 
      else if (state is StudentProgressError) {
      }
    });
  }
}

Widget _buildItem(BuildContext context, String titleText) {
  return Expanded(
    child: Text(
      titleText,
      style: Theme.of(context).textTheme.displayMedium,
      overflow: TextOverflow.ellipsis,
    ),
  );
}
