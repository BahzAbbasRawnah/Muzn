import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzn/models/enums.dart';
import 'package:muzn/models/student_progress.dart'; // Import the StudentProgress model
import 'package:muzn/services/database_service.dart';

// events/student_progress_event.dart
abstract class StudentProgressEvent extends Equatable {
  const StudentProgressEvent();

  @override
  List<Object> get props => [];
}

class AddStudentProgress extends StudentProgressEvent {
  final StudentProgress studentProgress;

  const AddStudentProgress({
    required this.studentProgress,
  });

  @override
  List<Object> get props => [studentProgress];
}

// states/student_progress_state.dart
abstract class StudentProgressState extends Equatable {
  const StudentProgressState();

  @override
  List<Object> get props => [];
}

class StudentProgressInitial extends StudentProgressState {}

class StudentProgressLoading extends StudentProgressState {}

class StudentProgressAdded extends StudentProgressState {}

class StudentProgressError extends StudentProgressState {
  final String message;

  const StudentProgressError(this.message);

  @override
  List<Object> get props => [message];
}

// bloc/student_progress_bloc.dart
class StudentProgressBloc
    extends Bloc<StudentProgressEvent, StudentProgressState> {
  final DatabaseManager _databaseManager = DatabaseManager();
  late StudentProgress _studentProgress; // Store student progress data

  StudentProgressBloc() : super(StudentProgressInitial()) {
    on<AddStudentProgress>(_onAddStudentProgress);
  }

  void setStudentProgress(StudentProgress studentProgress) {
    _studentProgress = studentProgress;
  }

Future<void> _onAddStudentProgress(
  AddStudentProgress event,
  Emitter<StudentProgressState> emit,
) async {
  emit(StudentProgressLoading()); // Emit loading state

  try {
    final db = await _databaseManager.database;

    // Create a new map without 'circle_id'
    final progressData = Map<String, dynamic>.from(event.studentProgress.toMap())
      ..remove('circle_id')
      ..remove('id');

    // Insert the student progress data into the database
    final result = await db.insert('StudentProgress', progressData);

    // Check if the insertion was successful
    if (result > 0) {
      // Update the Homework table to mark the homework as selected
      await db.rawUpdate(
        'UPDATE Homework SET checked = 1 WHERE id = ?',
        [event.studentProgress.homeworkId],
      );

      emit(StudentProgressAdded()); // Emit success state
    } else {
      emit(StudentProgressError('Failed to insert student progress'));
    }
  } catch (e) {
    // Emit error state with the exception message
    emit(StudentProgressError('An error occurred: ${e.toString()}'));
  }

  }
}
