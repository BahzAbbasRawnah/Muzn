import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muzn/models/statistics_student.dart';
import 'package:muzn/services/database_service.dart';

abstract class StatisticsEvent extends Equatable {
  const StatisticsEvent();

  @override
  List<Object> get props => [];
}

class FetchStatistics extends StatisticsEvent {
  final int teacherId;
  const FetchStatistics({required this.teacherId});

  @override
  List<Object> get props => [teacherId];
}

abstract class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object> get props => [];
}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final int schoolCount;
  final int circleCount;
  final int studentCount;
  final List<StatisticsStudent> topPresentStudents;
  final List<StatisticsStudent> topAbsentStudents;

  const StatisticsLoaded({
    required this.schoolCount,
    required this.circleCount,
    required this.studentCount,
    required this.topPresentStudents,
    required this.topAbsentStudents,
  });

  @override
  List<Object> get props => [
        schoolCount,
        circleCount,
        studentCount,
        topPresentStudents,
        topAbsentStudents,
      ];
}

class StatisticsError extends StatisticsState {
  final String message;

  const StatisticsError(this.message);

  @override
  List<Object> get props => [message];
}

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final DatabaseManager _databaseManager = DatabaseManager();

  StatisticsBloc() : super(StatisticsInitial()) {
    on<FetchStatistics>(_onFetchStatistics);
  }

  Future<void> _onFetchStatistics(
    FetchStatistics event,
    Emitter<StatisticsState> emit,
  ) async {
    emit(StatisticsLoading());

    try {
      final schoolCount = await _fetchSchoolCount(event.teacherId);
      final circleCount = await _fetchCircleCount(event.teacherId);
      final studentCount = await _fetchStudentCount(event.teacherId);
      final topStudents = await _fetchTopStudents(event.teacherId);

      emit(
        StatisticsLoaded(
          schoolCount: schoolCount,
          circleCount: circleCount,
          studentCount: studentCount,
          topPresentStudents: topStudents['present'] ?? [],
          topAbsentStudents: topStudents['absent'] ?? [],
        ),
      );
    } catch (e) {
      emit(StatisticsError('Failed to fetch statistics: $e'));
    }
  }

  Future<int> _fetchSchoolCount(int teacherId) async {
    final db = await _databaseManager.database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) AS count FROM School WHERE teacher_id = ?', [teacherId]);
    return (result.isNotEmpty ? result.first['count'] as int? : 0) ?? 0;
  }

  Future<int> _fetchCircleCount(int teacherId) async {
    final db = await _databaseManager.database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) AS count FROM Circle WHERE teacher_id = ?', [teacherId]);
    return (result.isNotEmpty ? result.first['count'] as int? : 0) ?? 0;
  }

  Future<int> _fetchStudentCount(int teacherId) async {
    final db = await _databaseManager.database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) AS count FROM Student WHERE teacher_id = ?', [teacherId]);
    return (result.isNotEmpty ? result.first['count'] as int? : 0) ?? 0;
  }

  Future<Map<String, List<StatisticsStudent>>> _fetchTopStudents(int teacherId) async {
    final db = await _databaseManager.database;
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1));

    final presentQuery = '''
      SELECT sa.student_id, u.full_name, COUNT(*) AS count
      FROM StudentAttendance sa
      INNER JOIN Student st ON sa.student_id = st.id
      LEFT JOIN User u ON st.user_id = u.id
      WHERE sa.status = 'present' 
        AND st.teacher_id = ?
        AND sa.attendance_date BETWEEN ? AND ?
      GROUP BY sa.student_id
      ORDER BY count DESC
      LIMIT 3;
    ''';

    final absentQuery = '''
      SELECT sa.student_id, u.full_name, COUNT(*) AS count
      FROM StudentAttendance sa
      INNER JOIN Student st ON sa.student_id = st.id
      LEFT JOIN User u ON st.user_id = u.id
      WHERE sa.status = 'absent' 
        AND st.teacher_id = ?
        AND sa.attendance_date BETWEEN ? AND ?
      GROUP BY sa.student_id
      ORDER BY count DESC
      LIMIT 3;
    ''';

    final presentResults = await db.rawQuery(presentQuery, [
      teacherId,
      startOfMonth.toIso8601String(),
      endOfMonth.toIso8601String()
    ]);

    final absentResults = await db.rawQuery(absentQuery, [
      teacherId,
      startOfMonth.toIso8601String(),
      endOfMonth.toIso8601String()
    ]);

    return {
      'present': presentResults.map((e) => StatisticsStudent.fromMap(e)).toList(),
      'absent': absentResults.map((e) => StatisticsStudent.fromMap(e)).toList(),
    };
  }
}
