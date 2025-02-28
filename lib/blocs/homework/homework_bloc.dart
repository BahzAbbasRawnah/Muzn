import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muzn/models/student_progress_history.dart';
import 'package:muzn/services/database_service.dart';
import 'package:muzn/models/homework.dart';

// Events
abstract class HomeworkEvent extends Equatable {
  // final BuildContext context;

  // const HomeworkEvent(this.context);

  @override
  List<Object> get props => [];
}

class LoadHomeworkEvent extends HomeworkEvent {
  int studentId;

  LoadHomeworkEvent(this.studentId);

  @override
  List<Object> get props => [studentId];
}

class LoadHistoryEvent extends HomeworkEvent {
  final int studentId;

  LoadHistoryEvent(BuildContext context, this.studentId);

  @override
  List<Object> get props => [studentId];
}

class AddHomeworkEvent extends HomeworkEvent {
  final Homework homework;

  AddHomeworkEvent(BuildContext context, this.homework);

  @override
  List<Object> get props => [homework];
}

class UpdateHomeworkEvent extends HomeworkEvent {
  final Homework homework;

  UpdateHomeworkEvent(this.homework);

  // : super(context);

  @override
  List<Object> get props => [homework];
}

class DeleteHomeworkEvent extends HomeworkEvent {
  final int homeworkId;

  DeleteHomeworkEvent(this.homeworkId);

  // : super(context);

  @override
  List<Object> get props => [homeworkId];
}

// States
abstract class HomeworkState extends Equatable {
  const HomeworkState();

  @override
  List<Object> get props => [];
}

class HomeworkInitial extends HomeworkState {}

class HomeworkLoading extends HomeworkState {}

class HomeworkAdded extends HomeworkState {}

class HomeworkUpdated extends HomeworkState {}

class HomeworkDeleted extends HomeworkState {}

class HomeworkLoaded extends HomeworkState {
  final List<Homework> homeworkList;

  const HomeworkLoaded(this.homeworkList);

  @override
  List<Object> get props => [homeworkList];
}

class ProgressHistoryLoaded extends HomeworkState {
  final List<StudentProgressHistory> ProgressHistoryList;

  const ProgressHistoryLoaded(this.ProgressHistoryList);

  @override
  List<Object> get props => [ProgressHistoryList];
}

class HomeworkError extends HomeworkState {
  final String message;

  const HomeworkError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class HomeworkBloc extends Bloc<HomeworkEvent, HomeworkState> {
  final DatabaseManager _databaseManager = DatabaseManager();
  List<Homework>? listHomeWork;
  List<StudentProgressHistory>? listStudentProgressHistory;

  HomeworkBloc() : super(HomeworkInitial()) {
    on<LoadHomeworkEvent>(_onLoadHomework);
    on<LoadHistoryEvent>(_onLoadHistory);

    on<AddHomeworkEvent>(_onAddHomework);
    on<UpdateHomeworkEvent>(_onUpdateHomework);
    on<DeleteHomeworkEvent>(_onDeleteHomework);
  }

//
// Future<void> _onLoadHomework(
//     LoadHomeworkEvent event, Emitter<HomeworkState> emit) async {
//   emit(HomeworkLoading());
//   try {
//     final db = await _databaseManager.database;
//
//     // Fetch homework with category name
//     final List<Map<String, dynamic>> results = await db.rawQuery('''
//       SELECT h.*, cat.name AS category_name
//       FROM Homework h
//       LEFT JOIN CirclesCategory cat ON h.circle_category_id = cat.id
//       WHERE h.student_id = ? AND h.checked = ?
//     ''', [event.studentId, 0]);
//
//     // Convert results to a list of Homework objects
//     final homeworkList = results.map((map) {
//       return Homework.fromMap({
//         ...map,
//         'category_name': map['category_name'] ?? '' // Ensure category name is handled properly
//       });
//     }).toList();
// listHomeWork=homeworkList;
//     emit(HomeworkLoaded(homeworkList));
//   } catch (e, stackTrace) {
//     debugPrint("Error loading homework: $e\n$stackTrace");
//     emit(HomeworkError('Failed to load homework: $e')); // Include error details for debugging
//   }
// }

  Future<void> _onLoadHomework(
      LoadHomeworkEvent event, Emitter<HomeworkState> emit) async {
    print("LoadHomeworkEvent received for student ID: ${event.studentId}");

    emit(HomeworkLoading());

    try {
      final db = await _databaseManager.database;

      final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT h.*, cat.name AS category_name 
      FROM Homework h
      LEFT JOIN CirclesCategory cat ON h.circle_category_id = cat.id
      WHERE h.student_id = ? AND h.checked = ?
    ''', [event.studentId, 0]);

      final homeworkList = results.map((map) {
        return Homework.fromMap({
          ...map,
          'category_name': map['category_name'] ?? ''
          // Ensure category name is handled properly
        });
      }).toList();
      listHomeWork = homeworkList;

      print("Loaded ${homeworkList.length} homework items.");

      emit(HomeworkLoaded(homeworkList));
    } catch (e, stackTrace) {
      debugPrint("Error loading homework: $e\n$stackTrace");
      emit(HomeworkError('Failed to load homework: $e'));
    }
  }

  Future<void> _onLoadHistory(
      LoadHistoryEvent event, Emitter<HomeworkState> emit) async {
    emit(HomeworkLoading());
    try {
      final db = await _databaseManager.database;
      final List<Map<String, dynamic>> results = await db.rawQuery('''
  SELECT h.*, sp.*, cat.name AS category_name
  FROM Homework h
  LEFT JOIN CirclesCategory cat ON h.circle_category_id = cat.id
  JOIN StudentProgress sp ON h.id = sp.homework_id
  WHERE h.student_id = ? AND h.checked = ?
''', [event.studentId, 1]);

      final progressHistoryList = results.map((map) {
        return StudentProgressHistory.fromMap(map);
      }).toList();
      listStudentProgressHistory = progressHistoryList;
      emit(ProgressHistoryLoaded(progressHistoryList));
    } catch (e) {
      emit(HomeworkError('Failed to load history \n' + e.toString()));
    }
  }

  // Future<void> _onAddHomework(
  //     AddHomeworkEvent event, Emitter<HomeworkState> emit) async {
  //   emit(HomeworkLoading());
  //   // try {
  //     await insertHomework(event.homework);
  //     emit(HomeworkAdded());
  //     add(LoadHomeworkEvent(event.homework.studentId));
  //   emit(HomeworkAdded());
  //   // } catch (e) {
  //   //   emit(HomeworkError(e.toString()));
  //   // }
  // }
  Future<void> _onAddHomework(
      AddHomeworkEvent event, Emitter<HomeworkState> emit) async {
    emit(HomeworkLoading());
    print("Inserting homework...");
    await insertHomework(event.homework);
    print("Homework inserted. Triggering reload...");
    add(LoadHomeworkEvent(event.homework.studentId));
    emit(HomeworkAdded());
    print("HomeworkAdded state emitted.");
  }

  Future<void> _onUpdateHomework(
      UpdateHomeworkEvent event, Emitter<HomeworkState> emit) async {
    emit(HomeworkLoading());
    try {
      final db = await _databaseManager.database;
      await db.update(
        'Homework',
        event.homework.toMap(),
        where: 'id = ?',
        whereArgs: [event.homework.id],
      );
      emit(HomeworkUpdated());
      // Refresh homework list after updating
      add(LoadHomeworkEvent(event.homework.studentId));
    } catch (e) {
      emit(HomeworkError(e.toString()));
    }
  }

  Future<void> _onDeleteHomework(
      DeleteHomeworkEvent event, Emitter<HomeworkState> emit) async {
    emit(HomeworkLoading());
    try {
      final db = await _databaseManager.database;
      await db.delete(
        'Homework',
        where: 'id = ?',
        whereArgs: [event.homeworkId],
      );
      emit(HomeworkDeleted());
      add(LoadHomeworkEvent(event.homeworkId));
    } catch (e) {
      emit(HomeworkError(e.toString()));
    }
  }

  Future<void> insertHomework(Homework homework) async {
    try {
      final db = await _databaseManager.database;
      final homeworkMap = homework.toMap();
      homeworkMap.remove('id');
      await db.insert('Homework', homeworkMap);
    } catch (e) {
      throw Exception('Failed to insert homework: $e');
    }
  }
}
