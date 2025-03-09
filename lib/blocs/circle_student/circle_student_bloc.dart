import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muzn/models/circle_student.dart';
import 'package:muzn/models/enums.dart';
import 'package:muzn/models/student.dart';
import 'package:muzn/models/user.dart';
import 'package:muzn/services/database_service.dart';

// Events
abstract class CircleStudentEvent extends Equatable {
  final BuildContext? context;

  const CircleStudentEvent(this.context);

  // @override
  // List<Object> get props => [context];
}

class LoadCircleStudents extends CircleStudentEvent {
  final int circleId;

   LoadCircleStudents(super.context,
    // super.context,
      {
    required this.circleId,
  });

  @override
  List<Object> get props => [ circleId];
}

class UpdateStudentAttendance extends CircleStudentEvent {
  final int studentId;
  final int circleId;
  String? studentUuid;
  String? circleUuid;

  final AttendanceStatuse status;

   UpdateStudentAttendance(
    super.context, {
    required this.studentId,
    required this.circleId,
         this.circleUuid,
         this.studentUuid,
    required this.status,
  });

  @override
  List<Object> get props => [ studentId, circleId, status];
}

class AddStudentToCircleEvent extends CircleStudentEvent {
  final int studentId;
  final int circleId;
  String? studentUuid;
  String? circleUuid;

   AddStudentToCircleEvent(
    super.context, {
    required this.studentId,
    required this.circleId,
         this.circleUuid,
         this.studentUuid,
  });

  @override
  List<Object> get props => [ studentId, circleId];
}

class DeleteStudentToCircleEvent extends CircleStudentEvent {
  final int studentId;
  final int circleId;

  const DeleteStudentToCircleEvent(
    super.context, {
    required this.studentId,
    required this.circleId,
  });

  @override
  List<Object> get props => [ studentId, circleId];
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
  final List<CircleStudent> students; // All students loaded from the database
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
class CircleStudentDeleted extends CircleStudentState {
  final String message;
  const CircleStudentDeleted(this.message);
}


// Bloc
class CircleStudentBloc extends Bloc<CircleStudentEvent, CircleStudentState> {
  final DatabaseManager _databaseManager = DatabaseManager();
  List<CircleStudent>? studentsList;
  int? circleId;

  CircleStudentBloc() : super(CircleStudentInitial()) {
    on<LoadCircleStudents>(_onLoadCircleStudents);
    on<UpdateStudentAttendance>(_onUpdateStudentAttendance);
    on<AddStudentToCircleEvent>(_onAddStudentToCircle);
    on<DeleteStudentToCircleEvent>(deleteStudentFromCircle);
  }

  Future<void> _onLoadCircleStudents(
    LoadCircleStudents event,
    Emitter<CircleStudentState> emit,
  ) async {
    print('start load circleStudents 00000000000000000000');
    // final today = DateTime.now().toIso8601String().split('T')[0];  // Get current date in "YYYY-MM-DD"

    emit(CircleStudentLoading());
    // try {
      final db = await _databaseManager.database;
    final today = DateTime.now().toIso8601String().split('T')[0]; // YYY
      // Load all students from the database
      final results = await db.rawQuery('''
      SELECT 
        cs.id,
        s.id as student_id,
        s.uuid as student_uuid,
        s.teacher_id,
        s.teacher_uuid,
        s.user_id,
        s.user_uuid,
        u.id as user_id,
        u.full_name,
        u.phone,
        u.email,
        u.country,
        u.country_code,
        u.gender,
        u.role as role,
        sa.status as today_attendance,
        sa.attendance_date as attendance_date
      FROM CircleStudent cs
      INNER JOIN Student s ON s.id = cs.student_id
      INNER JOIN User u ON u.id = s.user_id
      LEFT JOIN StudentAttendance sa ON sa.student_id = cs.student_id 
        AND sa.circle_id = ? 
        AND date(sa.attendance_date) =? 
        AND sa.deleted_at IS NULL
      WHERE cs.circle_id = ? 
        AND cs.deleted_at IS NULL
    ''', [event.circleId,today, event.circleId]);
print("results.toString()");
print(results.toString());
      final students = results
          .map((row) => CircleStudent(
              id: row['id'] as int,
              student: Student(
                uuid: row['student_uuid'] as String,
                id: row['student_id'] as int,
                teacherId: row['teacher_id'] as int,
                teacherUuid: row['teacher_uuid'] as String?,
                userId: row['user_id'] as int,
                userUuid: row['user_uuid'] as String?,
                user: User(
                  uuid: row['user_uuid'] as String?,
                  id: row['user_id'] as int,
                  fullName: row['full_name'] as String,
                  phone: row['phone'] as String,
                  email: row['email'] as String,
                  country: row['country'] as String?,
                  countryCode: row['country_code'] as String?,
                  gender: row['gender'] as String,
                  role: row['role'] as String,
                ),
              ),
              todayAttendance: row['today_attendance'] == null
                  ? AttendanceStatuse.none
                  : AttendanceStatuse.values.firstWhere(
                      (e) => e.name == (row['today_attendance'] as String),
                      orElse: () => AttendanceStatuse.none,
                    )))
          .toList();

      // Get attendance summary
      studentsList=students;
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
      circleId = event.circleId;
      emit(CircleStudentsLoaded(
        students: students,
        attendanceSummary: summary,
      ));
    // } catch (e) {
    //   emit(CircleStudentError(e.toString()));
    // }
  }

  Future<void> _onUpdateStudentAttendance(
    UpdateStudentAttendance event,
    Emitter<CircleStudentState> emit,
  ) async {
    try {
      final db = await _databaseManager.database;
      print('event.studentId');
      print(event.studentId);
      print('event.circleId');
      print(event.circleId);
      print('----------------------------------------------------------');

      // Check if attendance record exists for today
      final today = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD
      final existing = await db.query(
        'StudentAttendance',
        where: '''
    student_id = ? AND 
    circle_id = ? AND
    DATE(attendance_date) = ? AND
      deleted_at IS NULL
  ''',
        whereArgs: [event.studentId, event.circleId, today],
      );
      //  deleted_at IS NULL
      print("Query: student_id = ${event.studentId}, circle_id = ${event.circleId}, date = $today");
      print("Existing Records: $existing");
      if (existing.isEmpty) {
        // Insert new record
       int userid= await db.insert('StudentAttendance', {
          'student_id': event.studentId,
          'student_uuid': event.studentUuid,
          'circle_id': event.circleId,
          'circle_uuid': event.circleUuid,

          'status': event.status.name,

          'attendance_date': DateTime.now().toIso8601String().split('T')[0], // Stores only "YYYY-MM-DD"

          // 'attendance_date': DateTime.now().toIso8601String(),
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });

        print(" attendance record not exists for today 999999999");
        print(" inserted id is ");
        print(userid);
      } else {
        // Update existing record
        await db.update(
          'StudentAttendance',
          {
            'status': event.status.name,
            'updated_at': DateTime.now().toIso8601String(),
          },
          where: '''
            student_id = ? AND 
            circle_id = ? AND 
            DATE(attendance_date) = DATE('now') AND
            deleted_at IS NULL
          ''',
          whereArgs: [event.studentId, event.circleId],
        );

        print(" attendance record updated for today998887787");
      }

      add(LoadCircleStudents(event.context, circleId: event.circleId));
    } catch (e) {
      emit(CircleStudentError(e.toString()));
    }
  }

  Future<void> _onAddStudentToCircle(
    AddStudentToCircleEvent event,
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
          'student_uuid': event.studentUuid,
          'circle_id': event.circleId,
          'circle_uuid': event.circleUuid,
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

  Future<void> deleteStudentFromCircle(DeleteStudentToCircleEvent event,
      Emitter<CircleStudentState> emit) async {
    try {
      final db = await _databaseManager.database;

      // Check if student is in circle before attempting to delete
      final existing = await db.query(
        'CircleStudent',
        where: 'student_id = ? AND circle_id = ? AND deleted_at IS NULL',
        whereArgs: [event.studentId, event.circleId],
      );

      if (existing.isNotEmpty) {
        // Delete student from circle
        await db.delete(
          'CircleStudent',
          where: 'student_id = ? AND circle_id = ?',
          whereArgs: [event.studentId, event.circleId],
        );

        // Emit a success state
        // emit(CircleStudentDeleted());
      } else {
        emit(CircleStudentError('Student not found in the circle.'));
      }
add(LoadCircleStudents(event.context, circleId: circleId!));
      // Reload students
      // add(LoadCircleStudents(context, circleId: circleId));
    } catch (e) {
      emit(CircleStudentError(e.toString()));
    }
  }
}
