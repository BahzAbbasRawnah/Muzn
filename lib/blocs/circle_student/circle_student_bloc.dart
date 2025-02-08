import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muzn/models/circle_student.dart';
import 'package:muzn/models/enums.dart';
import 'package:muzn/services/database_service.dart';

// Events
abstract class CircleStudentEvent extends Equatable {
  final BuildContext context;
  const CircleStudentEvent(this.context);

  @override
  List<Object> get props => [context];
}

class LoadCircleStudents extends CircleStudentEvent {
  final int circleId;
  final String? searchQuery;
  final AttendanceStatuse? filterStatus;

  const LoadCircleStudents(
    BuildContext context, {
    required this.circleId,
    this.searchQuery,
    this.filterStatus,
  }) : super(context);

  @override
  List<Object> get props => [
        context,
        circleId,
        if (searchQuery != null) searchQuery!,
        if (filterStatus != null) filterStatus!,
      ];
}

class UpdateStudentAttendance extends CircleStudentEvent {
  final int studentId;
  final int circleId;
  final AttendanceStatuse status;

  const UpdateStudentAttendance(
    BuildContext context, {
    required this.studentId,
    required this.circleId,
    required this.status,
  }) : super(context);

  @override
  List<Object> get props => [context, studentId, circleId, status];
}

class AddStudentToCircle extends CircleStudentEvent {
  final int studentId;
  final int circleId;

  const AddStudentToCircle(
    BuildContext context, {
    required this.studentId,
    required this.circleId,
  }) : super(context);

  @override
  List<Object> get props => [context, studentId, circleId];
}

// States
abstract class CircleStudentState extends Equatable {
  const CircleStudentState();

  @override
  List<Object> get props => [];
}

class CircleStudentInitial extends CircleStudentState {}

class CircleStudentLoading extends CircleStudentState {}

class CircleStudentsLoaded extends CircleStudentState {
  final List<CircleStudent> students;
  final Map<AttendanceStatuse, int> attendanceSummary;

  const CircleStudentsLoaded({
    required this.students,
    required this.attendanceSummary,
  });

  @override
  List<Object> get props => [students, attendanceSummary];
}

class CircleStudentError extends CircleStudentState {
  final String message;

  const CircleStudentError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class CircleStudentBloc extends Bloc<CircleStudentEvent, CircleStudentState> {
  final DatabaseManager _databaseManager = DatabaseManager();

  CircleStudentBloc() : super(CircleStudentInitial()) {
    on<LoadCircleStudents>(_onLoadCircleStudents);
    on<UpdateStudentAttendance>(_onUpdateStudentAttendance);
    on<AddStudentToCircle>(_onAddStudentToCircle);
  }

  Future<void> _onLoadCircleStudents(
    LoadCircleStudents event,
    Emitter<CircleStudentState> emit,
  ) async {
    emit(CircleStudentLoading());
    try {
      final db = await _databaseManager.database;

      // Build the query with proper joins
      String query = '''
        SELECT 
          s.id as student_id,
          u.full_name,
          u.phone,
          u.email,
          sa.status as today_attendance
        FROM CircleStudent cs
        INNER JOIN Student s ON s.id = cs.student_id
        INNER JOIN User u ON u.id = s.user_id
        LEFT JOIN StudentAttendance sa ON sa.student_id = cs.student_id 
          AND sa.circle_id = ? 
          AND date(sa.attendance_date) = date('now')
          AND sa.deleted_at IS NULL
        WHERE cs.circle_id = ? 
          AND cs.deleted_at IS NULL
      ''';

      List<dynamic> args = [event.circleId, event.circleId];

      if (event.searchQuery != null && event.searchQuery!.isNotEmpty) {
        query += ' AND u.full_name LIKE ?';
        args.add('%${event.searchQuery}%');
      }

      if (event.filterStatus != null) {
        query += ' AND sa.status = ?';
        args.add(event.filterStatus!.name);
      }

      query += ' ORDER BY u.full_name';

      final results = await db.rawQuery(query, args);

      // Get attendance summary
      final summaryResults = await db.rawQuery('''
        SELECT 
          COALESCE(sa.status, 'none') as status,
          COUNT(*) as count
        FROM CircleStudent cs
        LEFT JOIN StudentAttendance sa ON sa.student_id = cs.student_id 
          AND sa.circle_id = ?
          AND date(sa.attendance_date) = date('now')
          AND sa.deleted_at IS NULL
        WHERE cs.circle_id = ? 
          AND cs.deleted_at IS NULL
        GROUP BY sa.status
      ''', [event.circleId, event.circleId]);

      final Map<AttendanceStatuse, int> summary = {};
      for (var row in summaryResults) {
        final status = AttendanceStatuse.values.firstWhere(
          (e) => e.name == (row['status'] as String),
          orElse: () => AttendanceStatuse.none,
        );
        summary[status] = row['count'] as int;
      }

      emit(CircleStudentsLoaded(
        students: results.map((row) => CircleStudent.fromMap(row)).toList(),
        attendanceSummary: summary,
      ));
    } catch (e) {
      emit(CircleStudentError(e.toString()));
    }
  }

  Future<void> _onUpdateStudentAttendance(
    UpdateStudentAttendance event,
    Emitter<CircleStudentState> emit,
  ) async {
    try {
      final db = await _databaseManager.database;

      // Check if attendance record exists for today
      final existing = await db.query(
        'StudentAttendance',
        where: '''
          student_id = ? AND 
          circle_id = ? AND 
          DATE(attendance_date) = DATE('now') AND
          deleted_at IS NULL
        ''',
        whereArgs: [event.studentId, event.circleId],
      );

      if (existing.isEmpty) {
        // Insert new record
        await db.insert('StudentAttendance', {
          'student_id': event.studentId,
          'circle_id': event.circleId,
          'status': event.status.name,
          'attendance_date': DateTime.now().toIso8601String(),
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      } else {
        // Update existing record
        await db.update(
          'StudentAttendance',
          {
            'status': event.status.name,
            'updated_at': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [existing.first['id']],
        );
      }

      // After updating attendance, reload the students list
      // First emit loading state
      emit(CircleStudentLoading());

      // Then load the updated data using the same query as _onLoadCircleStudents
      String query = '''
        SELECT 
          s.id as student_id,
          u.full_name,
          u.phone,
          u.email,
          sa.status as today_attendance
        FROM CircleStudent cs
        INNER JOIN Student s ON s.id = cs.student_id
        INNER JOIN User u ON u.id = s.user_id
        LEFT JOIN StudentAttendance sa ON sa.student_id = cs.student_id 
          AND sa.circle_id = ? 
          AND date(sa.attendance_date) = date('now')
          AND sa.deleted_at IS NULL
        WHERE cs.circle_id = ? 
          AND cs.deleted_at IS NULL
        ORDER BY u.full_name
      ''';

      final results = await db.rawQuery(query, [event.circleId, event.circleId]);

      // Get attendance summary
      final summaryResults = await db.rawQuery('''
        SELECT 
          COALESCE(sa.status, 'none') as status,
          COUNT(*) as count
        FROM CircleStudent cs
        LEFT JOIN StudentAttendance sa ON sa.student_id = cs.student_id 
          AND sa.circle_id = ?
          AND date(sa.attendance_date) = date('now')
          AND sa.deleted_at IS NULL
        WHERE cs.circle_id = ? 
          AND cs.deleted_at IS NULL
        GROUP BY sa.status
      ''', [event.circleId, event.circleId]);

      final Map<AttendanceStatuse, int> summary = {};
      for (var row in summaryResults) {
        final status = AttendanceStatuse.values.firstWhere(
          (e) => e.name == (row['status'] as String),
          orElse: () => AttendanceStatuse.none,
        );
        summary[status] = row['count'] as int;
      }

      // Emit the updated state
      emit(CircleStudentsLoaded(
        students: results.map((row) => CircleStudent.fromMap(row)).toList(),
        attendanceSummary: summary,
      ));

    } catch (e) {
      emit(CircleStudentError(e.toString()));
    }
  }

  Future<void> _onAddStudentToCircle(
    AddStudentToCircle event,
    Emitter<CircleStudentState> emit,
  ) async {
    try {
      final db = await _databaseManager.database;

      // Check if student is already in circle
      final existing = await db.query(
        'CircleStudent',
        where: 'student_id = ? AND circle_id = ? AND deleted_at IS NULL',
        whereArgs: [event.studentId, event.circleId],
      );

      if (existing.isEmpty) {
        // Add student to circle
        await db.insert('CircleStudent', {
          'student_id': event.studentId,
          'circle_id': event.circleId,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      }

      // Reload students
      add(LoadCircleStudents(event.context, circleId: event.circleId));
    } catch (e) {
      emit(CircleStudentError(e.toString()));
    }
  }
}
