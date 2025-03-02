import 'package:bloc/bloc.dart';

import '../../models/attendance_record.dart';
import '../../models/enums.dart';
import '../../services/database_service.dart';
import 'student_history_state.dart';

// part 'student_history_state.dart';
class StudentHistoryCubit extends Cubit<StudentHistoryState> {
  final DatabaseManager _databaseManager=DatabaseManager();

  StudentHistoryCubit() : super(StudentHistoryInitial());

  Future<void> loadStudentHistory(int circleId, int studentId) async {
    emit(StudentHistoryLoading());
    try {
      final db = await _databaseManager.database;

      // Fetch attendance history for a student
      final results = await db.rawQuery('''
        SELECT 
          sa.id,
          sa.student_id,
          sa.circle_id,
          sa.attendance_date,
          sa.status
        FROM StudentAttendance sa
        WHERE sa.circle_id = ? 
          AND sa.student_id = ?
          AND sa.deleted_at IS NULL
        ORDER BY sa.attendance_date DESC
      ''', [circleId, studentId]);
print("results.toString()");
print(results.toString());
      final attendanceHistory = results.map((row) => AttendanceRecord(
        id: row['id'] as int,
        studentId: row['student_id'] as int,
        circleId: row['circle_id'] as int,
        attendanceDate: DateTime.parse(row['attendance_date'] as String),
        status: AttendanceStatuse.values.firstWhere(
              (e) => e.name == (row['status'] as String),
          orElse: () => AttendanceStatuse.none,
        ),
      )).toList();

      // Get attendance summary over time
      final summaryResults = await db.rawQuery('''
        SELECT 
          sa.status,
          COUNT(*) as count
        FROM StudentAttendance sa
        WHERE sa.circle_id = ?
          AND sa.student_id = ?
          AND sa.deleted_at IS NULL
        GROUP BY sa.status
      ''', [circleId, studentId]);

      final Map<AttendanceStatuse, int> summary = {};
      for (var row in summaryResults) {
        final status = AttendanceStatuse.values.firstWhere(
              (e) => e.name == (row['status'] as String),
          orElse: () => AttendanceStatuse.none,
        );
        summary[status] = row['count'] as int;
      }

      emit(StudentHistoryLoaded(
        attendanceHistory: attendanceHistory,
        attendanceSummary: summary,
      ));
    } catch (e) {
      emit(StudentHistoryError(e.toString()));
    }
  }
}
