import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/homework/homework_bloc.dart';
import 'package:muzn/models/homework.dart';
import 'package:muzn/models/quran_model.dart';
import 'package:muzn/views/widgets/circle_category.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_surah_dropdown.dart';
import 'package:muzn/views/widgets/custom_ayah_dropdown.dart';

class EditStudentHomeworkBottomSheet extends StatefulWidget {
   Homework homework;

   EditStudentHomeworkBottomSheet({super.key, required this.homework});

  @override
  _EditStudentHomeworkBottomSheetState createState() => _EditStudentHomeworkBottomSheetState();
}

class _EditStudentHomeworkBottomSheetState extends State<EditStudentHomeworkBottomSheet> {
  // Variables for editing homework details
  final List<Surah> surahList = QuranService.getAllSurahs();

  Surah? selectedFromSurah;
  int? selectedFromAyah;
  Surah? selectedToSurah;
  int? selectedToAyah;
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // Initialize with current homework data
    selectedFromSurah = surahList.firstWhere(
      (surah) => surah.number == widget.homework.startSurahNumber,
      orElse: () => surahList.first,
    );
    selectedFromAyah = widget.homework.startAyahNumber;
    selectedToSurah = surahList.firstWhere(
      (surah) => surah.number == widget.homework.endSurahNumber,
      orElse: () => surahList.first,
    );
    selectedToAyah = widget.homework.endAyahNumber;
    selectedCategoryId = widget.homework.circleCategoryId;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    'edit_student_homework'.trans(context),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 16),
Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'circle_category'.trans(context),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 8),
                      CircleCategorySelector(
initialSelectedCategoryId: selectedCategoryId,
                        onCategorySelected: (categoryId) {
                          setState(() {
                            selectedCategoryId = categoryId;
                          });
                        },
                      ),
                    ],
                  ),




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
                            selectedFromAyah = null; // Reset ayah when surah changes
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
                            selectedToAyah = null; // Reset ayah when surah changes
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

                CustomButton(
                  text: 'save'.trans(context),
                  onPressed: () {
                    _saveHomework();
                  },
                  icon: Icons.update,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveHomework() async {
    // Ensure all required fields are selected
    if (selectedFromSurah == null ||
        selectedFromAyah == null ||
        selectedToSurah == null ||
        selectedToAyah == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please_fill_all_fields'.trans(context))),
      );
      return;
    }

    // Create the updated Homework object
    Homework updatedHomework = Homework(
      uuid: widget.homework.uuid,
      id: widget.homework.id,
      circleId: widget.homework.circleId,
      circleUuid: widget.homework.circleUuid,
      circleCategoryId: selectedCategoryId ?? widget.homework.circleCategoryId,
      studentUuid: widget.homework.studentUuid,
      studentId: widget.homework.studentId,
      startSurahNumber: selectedFromSurah!.number,
      endSurahNumber: selectedToSurah!.number,
      startAyahNumber: selectedFromAyah!,
      endAyahNumber: selectedToAyah!,
      homeworkDate: widget.homework.homeworkDate,
      notes: widget.homework.notes,
      createdAt: widget.homework.createdAt,
      updatedAt: DateTime.now(),
      deletedAt: widget.homework.deletedAt,
      categoryName: widget.homework.categoryName,
      checked: widget.homework.checked,
    );

    // Call the BLoC event to save the homework
    context.read<HomeworkBloc>().add(UpdateHomeworkEvent(
            // context,
            updatedHomework,
          ),
        );

    Navigator.of(context).pop();
  }
}