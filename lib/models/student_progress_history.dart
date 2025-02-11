import 'homework.dart'; // Import the Homework model
import 'student_progress.dart'; // Import the StudentProgress model

class StudentProgressHistory {
  final Homework homework;
  final StudentProgress studentProgress;
  String? category_name;
  StudentProgressHistory({
    required this.homework,
    required this.studentProgress,
    this.category_name,
  });

  factory StudentProgressHistory.fromMap(Map<String, dynamic> map) {

    return StudentProgressHistory(
      homework: Homework.fromMap(map),
      studentProgress: StudentProgress.fromMap(map),
      category_name: map['category_name'],
    );
  }
}
