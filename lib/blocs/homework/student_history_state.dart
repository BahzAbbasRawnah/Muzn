import '../../models/attendance_record.dart';
import '../../models/enums.dart';

// part 'student_history_cubit.dart';

abstract class StudentHistoryState {}

class StudentHistoryInitial extends StudentHistoryState {}

class StudentHistoryLoading extends StudentHistoryState {}

class StudentHistoryLoaded extends StudentHistoryState {
  final List<AttendanceRecord> attendanceHistory;
  final Map<AttendanceStatuse, int> attendanceSummary;

  StudentHistoryLoaded({
    required this.attendanceHistory,
    required this.attendanceSummary,
  });
}

class StudentHistoryError extends StudentHistoryState {
  final String error;
  StudentHistoryError(this.error);
}
