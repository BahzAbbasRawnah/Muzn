import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/homework/homework_bloc.dart';
import 'package:muzn/models/homework.dart';
import 'package:muzn/models/quran_model.dart';
import 'package:muzn/views/widgets/circle_category.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_surah_dropdown.dart';
import 'package:muzn/views/widgets/custom_ayah_dropdown.dart';

class AddHomeworkBottomSheet extends StatefulWidget {
  final int studentId;
  final int circleId;
  final VoidCallback onHomeworkAdded;

   AddHomeworkBottomSheet(
      {super.key, required this.studentId, required this.circleId,required this.onHomeworkAdded});

  @override
  _AddHomeworkBottomSheetState createState() => _AddHomeworkBottomSheetState();
}

class _AddHomeworkBottomSheetState extends State<AddHomeworkBottomSheet> {
  final List<Surah> surahList = QuranService.getAllSurahs();
  Surah? selectedFromSurah;
  int? selectedFromAyah;
  Surah? selectedToSurah;
  int? selectedToAyah;
  int? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeworkBloc(),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      'add_student_homework'.trans(context),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Circle Categories
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'circle_category'.trans(context),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 8),
                      CircleCategorySelector(
                        onCategorySelected: (categoryId) {
                          setState(() {
                            selectedCategoryId = categoryId;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // First Row of Dropdowns
                  Row(
                    children: [
                      Expanded(
                        child: CustomSurahDropdown(
                          label: 'from_surah'.trans(context),
                          selectedSurah: selectedFromSurah,
                          surahList: surahList,
                          onChanged: (value) {
                            setState(() {
                              selectedFromSurah = value;
                              selectedFromAyah =
                                  null; // Reset ayah when surah changes
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomAyahDropdown(
                          label: 'from_ayah'.trans(context),
                          selectedAyah: selectedFromAyah,
                          maxAyah: selectedFromSurah?.ayat_count,
                          onChanged: selectedFromSurah != null
                              ? (value) {
                                  setState(() {
                                    selectedFromAyah = value;
                                  });
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Second Row of Dropdowns
                  Row(
                    children: [
                      Expanded(
                        child: CustomSurahDropdown(
                          label: 'to_surah'.trans(context),
                          selectedSurah: selectedToSurah,
                          surahList: surahList,
                          onChanged: (value) {
                            setState(() {
                              selectedToSurah = value;
                              selectedToAyah =
                                  null; // Reset ayah when surah changes
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomAyahDropdown(
                          label: 'to_ayah'.trans(context),
                          selectedAyah: selectedToAyah,
                          maxAyah: selectedToSurah?.ayat_count,
                          onChanged: selectedToSurah != null
                              ? (value) {
                                  setState(() {
                                    selectedToAyah = value;
                                  });
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Save Button
                  BlocBuilder<HomeworkBloc, HomeworkState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: 'save'.trans(context),
                        icon: Icons.save,
                        onPressed: () {
                          // Create Homework object
                          Homework homework = Homework(
                            id: 0,
                            circleCategoryId: selectedCategoryId!,
                            circleId: widget.circleId,
                            studentId: widget.studentId,
                            startSurahNumber: selectedFromSurah?.number ?? 0,
                            endSurahNumber: selectedToSurah?.number ?? 0,
                            startAyahNumber: selectedFromAyah ?? 1,
                            endAyahNumber: selectedToAyah ?? 1,
                            homeworkDate: DateTime.now(),
                            checked: 0,
                            notes: null,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          );

                          // Dispatch AddHomeworkEvent
                          BlocProvider.of<HomeworkBloc>(context)
                              .add(AddHomeworkEvent(context, homework));
                          // BlocProvider.of<HomeworkBloc>(context)
                          //     .add(LoadHomeworkEvent(widget.studentId));
                          // Get.off(StudentProgressScreen(widget.studentId))
                          // Close the bottom sheet after successful insertion
                          Navigator.pop(context);
                          widget.onHomeworkAdded();
                          // BlocProvider.of<HomeworkBloc>(context)
                          //     .add(LoadHomeworkEvent(widget.studentId));
                          // BlocProvider.of<HomeworkBloc>(context)
                          //     .add(LoadHistoryEvent(context, widget.studentId));
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
