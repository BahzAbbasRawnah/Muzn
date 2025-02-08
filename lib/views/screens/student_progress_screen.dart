import 'package:flutter/material.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/views/screens/progress_following_tab.dart';
import 'package:muzn/views/screens/progress_history_tab.dart';
import 'package:muzn/views/widgets/add_student_homework.dart';

class StudentProgressScreen extends StatefulWidget {
  const StudentProgressScreen({super.key});

  @override
  State<StudentProgressScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentProgressScreen> {
  final List<Map<String, dynamic>> homeworkItems = [
    {
      'title': 'الحفظ',
      'start_surah_number': 2, // Al-Baqarah
      'start_ayah_number': 1,
      'end_surah_number': 2,
      'end_ayah_number': 5,
    },
    {
      'title': 'المراجعة',
      'start_surah_number': 36, // Ya-Sin
      'start_ayah_number': 1,
      'end_surah_number': 36,
      'end_ayah_number': 12,
    },
    {
      'title': 'التلاوة',
      'start_surah_number': 67, // Al-Mulk
      'start_ayah_number': 1,
      'end_surah_number': 67,
      'end_ayah_number': 15,
    },
    {
      'title': 'التجويد',
      'start_surah_number': 78, // An-Naba
      'start_ayah_number': 1,
      'end_surah_number': 78,
      'end_ayah_number': 20,
    },
  ];


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text("student_homework".tr(context)),
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
            // First Tab: Today Homework List

            ProgressFollowingTab(homeworkItems: homeworkItems),

            // Second Tab: Old Homework  history List
            ProgressHistoryTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddHomeworkBottomSheet(context);
          },
          child: const Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
