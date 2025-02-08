import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/database_service.dart';
import '../../models/student.dart';
import '../../models/student_progress.dart';

// Events
abstract class StudentEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadStudents extends StudentEvent {
  final int? teacherId;
  LoadStudents({this.teacherId});
}

class LoadStudentProgress extends StudentEvent {
  final int studentId;
  final int circleId;
  LoadStudentProgress({required this.studentId, required this.circleId});
}

class UpdateStudentProgress extends StudentEvent {
  final StudentProgress progress;
  UpdateStudentProgress(this.progress);

  @override
  List<Object> get props => [progress];
}

// States
abstract class StudentState extends Equatable {
  @override
  List<Object> get props => [];
}

class StudentInitial extends StudentState {}
class StudentLoading extends StudentState {}
class StudentsLoaded extends StudentState {
  final List<Student> students;
  StudentsLoaded(this.students);

  @override
  List<Object> get props => [students];
}
class StudentProgressLoaded extends StudentState {
  final List<StudentProgress> progress;
  StudentProgressLoaded(this.progress);

  @override
  List<Object> get props => [progress];
}
class StudentError extends StudentState {
  final String message;
  StudentError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final DatabaseManager _databaseManager = DatabaseManager();

  StudentBloc() : super(StudentInitial()) {
    on<LoadStudents>(_onLoadStudents);
    on<LoadStudentProgress>(_onLoadStudentProgress);
    on<UpdateStudentProgress>(_onUpdateStudentProgress);
  }

  Future<void> _onLoadStudents(LoadStudents event, Emitter<StudentState> emit) async {
    emit(StudentLoading());
    try {
      final db = await _databaseManager.database;
      
      String query = '''
        SELECT s.*, u.full_name, u.email, u.phone
        FROM Student s
        JOIN User u ON s.user_id = u.id
        WHERE s.deleted_at IS NULL
      ''';
      
      List<Object?> whereArgs = [];
      if (event.teacherId != null) {
        query += ' AND s.teacher_id = ?';
        whereArgs.add(event.teacherId);
      }
      
      final List<Map<String, dynamic>> results = await db.rawQuery(query, whereArgs);
      final students = results.map((map) => Student.fromMap(map)).toList();
      emit(StudentsLoaded(students));
    } catch (e) {
      emit(StudentError('Failed to load students: ${e.toString()}'));
    }
  }

  Future<void> _onLoadStudentProgress(LoadStudentProgress event, Emitter<StudentState> emit) async {
    emit(StudentLoading());
    try {
      final db = await _databaseManager.database;
      final List<Map<String, dynamic>> results = await db.query(
        'StudentProgress',
        where: 'student_id = ? AND circle_id = ? AND deleted_at IS NULL',
        whereArgs: [event.studentId, event.circleId],
        orderBy: 'lesson_date DESC',
      );
      
      final progress = results.map((map) => StudentProgress.fromMap(map)).toList();
      emit(StudentProgressLoaded(progress));
    } catch (e) {
      emit(StudentError('Failed to load student progress: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateStudentProgress(UpdateStudentProgress event, Emitter<StudentState> emit) async {
    try {
      final db = await _databaseManager.database;
      await db.update(
        'StudentProgress',
        event.progress.toMap(),
        where: 'id = ?',
        whereArgs: [event.progress.id],
      );
      
      // Reload the progress after update
      add(LoadStudentProgress(
        studentId: event.progress.studentId,
        circleId: event.progress.circleId,
      ));
    } catch (e) {
      emit(StudentError('Failed to update progress: ${e.toString()}'));
    }
  }
}
