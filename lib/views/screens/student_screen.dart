import 'package:flutter/material.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_dropdown.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:muzn/views/widgets/lessons_item.dart';
import 'package:muzn/views/widgets/lesson_category.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final List<Map<String, String>> homeworkItems = [
    {
      'title': 'اليوم',
      'surah': 'الفاتحة',
      'ayah': '2',
      'status': 'Pending',
      'readingWrongs': '3',
      'tajweedWrongs': '2',
    },
    {
      'title': ' امس',
      'surah': 'النساء',
      'ayah': '5',
      'status': 'Completed',
      'readingWrongs': '1',
      'tajweedWrongs': '2',
    },
    {
      'title': ' قبلها',
      'surah': 'النساء',
      'ayah': '10',
      'status': 'Overdue',
      'readingWrongs': '5',
      'tajweedWrongs': '0',
    },
  ];

  // Dropdown values
  String? selectedValue1;
  String? selectedValue2;
  String? selectedValue3;
  String? selectedValue4;

  // Dropdown items
  final List<String> items = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title:  Text("student_lesson".tr(context)),
          centerTitle: true,
          bottom: TabBar(
            dividerColor: Colors.white,
            unselectedLabelColor: Colors.red,
            tabs: [
              Tab(
                child: Text('following_tab'.tr(context),
                    style: TextStyle(color: Colors.white)),
              ),
              Tab(
                child: Text('progress_tab'.tr(context),
                    style: Theme.of(context).textTheme.displayMedium),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // First Tab: Homework List

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  // Screen header
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 15,
                                backgroundImage: AssetImage(
                                    'assets/images/avatar_placeholder.png'), // Safe asset path
                              ),
                              const SizedBox(width: 16),
                               Text("ندى المطرفي",style: Theme.of(context).textTheme.displayMedium,),
                               Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.edit,
                                  size: 28,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.delete,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Homework List
                  Expanded(
                    child: ListView.builder(
                      itemCount: homeworkItems.length,
                      itemBuilder: (context, index) {
                        final lesson = homeworkItems[index];
                        return LessonsItem(
                          title: lesson['title']!,
                          surah: lesson['surah']!,
                          ayah: lesson['ayah']!,
                          readingWrongs: lesson['readingWrongs']!,
                          tajweedWrongs: lesson['tajweedWrongs']!,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Second Tab: Additional Content
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  // Screen header (same as the first tab)
                   Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 15,
                                backgroundImage: AssetImage(
                                    'assets/images/avatar_placeholder.png'), // Safe asset path
                              ),
                              const SizedBox(width: 16),
                               Text("ندى المطرفي",style: Theme.of(context).textTheme.displayMedium,),
                               Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.edit,
                                  size: 28,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.delete,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Additional content for the second tab
                  Expanded(
                    child: Center(
                      child: Text(
                        'second_tab_content'.tr(context),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddLessonBottomSheet(
                context); // Open bottom sheet on FAB click
          },
          child: const Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

// Show bottom sheet to add a new lesson
  void _showAddLessonBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ensure the bottom sheet can be scrolled
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Ensure the column takes minimum space
                children: [
                  Center(
                    child: Text(
                      'add_student_lesson'.tr(context),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      LessonCategoryItem(
                        label: "حفظ وتجويد",
                        value: true,
                        onChanged: (value) {},
                      ),
                      LessonCategoryItem(
                        label: "تلاوة",
                        value: false,
                        onChanged: (value) {},
                      ),
                      LessonCategoryItem(
                        label: "مراجعة",
                        value: false,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // First Row of Dropdowns
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropdown(
                          label: 'from_surah'.tr(context),
                          items: items,
                          selectedValue: selectedValue1,
                          onChanged: (newValue) {
                            setState(() {
                              selectedValue1 = newValue;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomDropdown(
                          label: 'from_ayah'.tr(context),
                          items: items,
                          selectedValue: selectedValue2,
                          onChanged: (newValue) {
                            setState(() {
                              selectedValue2 = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Second Row of Dropdowns
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropdown(
                          label: 'to_surah'.tr(context),
                          items: items,
                          selectedValue: selectedValue3,
                          onChanged: (newValue) {
                            setState(() {
                              selectedValue3 = newValue;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomDropdown(
                          label: 'to_ayah'.tr(context),
                          items: items,
                          selectedValue: selectedValue4,
                          onChanged: (newValue) {
                            setState(() {
                              selectedValue4 = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Input Quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("reading_wrongs".tr(context),style: Theme.of(context).textTheme.labelMedium,),
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
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context).primaryColor),
                              ),
                              isBordered: true,
                              plusBtn: Icon(
                                Icons.plus_one,
                                 color: Colors.green,
                                 size: 50,),
                              minusBtn: Icon(
                                Icons.exposure_minus_1,
                                color: Colors.red,
                                size: 50,
                              ),
                              
                            ),
                          ),
                        ],
                      ),
                         Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("reading_wrongs".tr(context),style: Theme.of(context).textTheme.labelMedium,),
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
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context).primaryColor),
                              ),
                              isBordered: true,
                              plusBtn: Icon(
                                Icons.plus_one,
                                 color: Colors.green,
                                 size: 50,),
                              minusBtn: Icon(
                                Icons.exposure_minus_1,
                                color: Colors.red,
                                size: 50,
                              ),
                              
                            ),
                          ),
                        ],
                      ),
                     
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Save Button
                  CustomButton(
                    text: 'update'.tr(context),
                    icon: Icons.update,
                    onPressed: () {
                      // Handle save action
                      Navigator.pop(context); // Close the bottom sheet
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
