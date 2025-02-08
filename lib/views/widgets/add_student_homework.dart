import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/circle_category/circle_category_bloc.dart';
import 'package:muzn/models/quran_model.dart';
import 'package:muzn/views/widgets/circle_category.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_surah_dropdown.dart';
import 'package:muzn/views/widgets/custom_ayah_dropdown.dart';

class AddHomeworkBottomSheet extends StatefulWidget {
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
      create: (context) => CircleCategoryBloc(),
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
                      'add_student_homework'.tr(context),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Circle Categories
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'circle_category'.tr(context),
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
                          label: 'from_surah'.tr(context),
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
                          label: 'from_ayah'.tr(context),
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
                          label: 'to_surah'.tr(context),
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
                          label: 'to_ayah'.tr(context),
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

                  // Input Quantity for Mistakes
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     _buildInputQtyField(
                  //         context, "reading_wrongs", Colors.green, Colors.red),
                  //     _buildInputQtyField(
                  //         context, "tashkeel_wrongs", Colors.green, Colors.red),
                  //     _buildInputQtyField(
                  //         context, "tajweed_wrongs", Colors.green, Colors.red),
                  //   ],
                  // ),
                  const SizedBox(height: 40),

                  // Save Button
                  CustomButton(
                    text: 'save'.tr(context),
                    icon: Icons.save,
                    onPressed: () {
                      // Handle the selected values
                      print('Selected category: $selectedCategoryId');
                      print('From Surah: ${selectedFromSurah?.number}, Ayah: $selectedFromAyah');
                      print('To Surah: ${selectedToSurah?.number}, Ayah: $selectedToAyah');
                      Navigator.pop(context);
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

  Widget _buildInputQtyField(
      BuildContext context, String label, Color plusColor, Color minusColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.tr(context),
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 2),
        InputQty(
          maxVal: 100,
          initVal: 0,
          steps: 1,
          minVal: 0,
          qtyFormProps: QtyFormProps(enableTyping: true),
          decoration: QtyDecorationProps(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(width: 1, color: Theme.of(context).primaryColor),
            ),
            isBordered: true,
            plusBtn: Icon(Icons.plus_one, color: plusColor, size: 30),
            minusBtn: Icon(Icons.exposure_minus_1, color: minusColor, size: 30),
          ),
        ),
      ],
    );
  }
}

void showAddHomeworkBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => AddHomeworkBottomSheet(),
  );
}
