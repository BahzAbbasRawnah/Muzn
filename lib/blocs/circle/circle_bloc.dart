import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muzn/blocs/auth/auth_bloc.dart';
import '../../models/circle.dart';
import '../../services/database_service.dart';

// Events
abstract class CircleEvent extends Equatable {
  const CircleEvent();
  
  @override
  List<Object> get props => [];
}

class LoadCircles extends CircleEvent {
  final int? schoolId;
  final int teacherId;

  const LoadCircles({this.schoolId, required this.teacherId});
  
  @override
  List<Object> get props => [teacherId, if (schoolId != null) schoolId!];
}

class AddCircle extends CircleEvent {
  final Circle circle;

  const AddCircle({required this.circle});

  @override
  List<Object> get props => [circle];
}

class UpdateCircle extends CircleEvent {
  final Circle circle;
  const UpdateCircle({required this.circle});

  @override
  List<Object> get props => [circle];
}

class DeleteCircle extends CircleEvent {
  final int circleId;
  final int teacherId;

  const DeleteCircle(this.circleId, this.teacherId);

  @override
  List<Object> get props => [circleId, teacherId];
}

// States
abstract class CircleState extends Equatable {
  const CircleState();

  @override
  List<Object> get props => [];
}

class CircleInitial extends CircleState {}

class CircleLoading extends CircleState {}

class CirclesLoaded extends CircleState {
  final List<Circle> circles;

  const CirclesLoaded(this.circles);

  @override
  List<Object> get props => [circles];
}

class CircleError extends CircleState {
  final String message;

  const CircleError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class CircleBloc extends Bloc<CircleEvent, CircleState> {
  final DatabaseManager _databaseManager = DatabaseManager();
  List<Circle>? circlesList;
  CircleBloc() : super(CircleInitial()) {
    on<LoadCircles>(_onLoadCircles);
    on<AddCircle>(_onAddCircle);
    on<UpdateCircle>(_onUpdateCircle);
    on<DeleteCircle>(_onDeleteCircle);
  }
Future<void> _onLoadCircles(LoadCircles event, Emitter<CircleState> emit) async {
  emit(CircleLoading());
  try {
    final db = await _databaseManager.database;

    // Build the SQL query
    final query = '''
      SELECT 
        c.*,
        cc.name as category_name,
        s.name as school_name,
      COUNT(DISTINCT cs.student_id) as student_count
      FROM Circle c
      LEFT JOIN CirclesCategory cc ON c.circle_category_id = cc.id
      LEFT JOIN School s ON c.school_id = s.id
      LEFT JOIN CircleStudent cs ON c.id = cs.circle_id AND cs.deleted_at IS NULL
      WHERE c.deleted_at IS NULL 
        AND c.teacher_id = ? -- Filter by teacher_id
        ${event.schoolId != null ? 'AND c.school_id = ?' : ''} -- Optional school filter
      GROUP BY c.id
      ORDER BY c.created_at DESC
    ''';

    // Prepare query arguments
    final List<dynamic> args = [event.teacherId];
    if (event.schoolId != null) {
      args.add(event.schoolId);
    }

    // Execute the query
    final List<Map<String, dynamic>> results = await db.rawQuery(query, args);

    // Map results to Circle objects
    final circles = results.map((map) => Circle.fromMap(map)).toList();

    // Emit the loaded state
    circlesList=circles;
    emit(CirclesLoaded(circles));
  } catch (e) {
    // Handle errors
    emit(CircleError('Failed to load circles: $e'));
  }
}

  Future<void> _onAddCircle(AddCircle event, Emitter<CircleState> emit) async {
    emit(CircleLoading());
    try {
      final db = await _databaseManager.database;
      final now = DateTime.now().toIso8601String();

      // Insert the circle using the Circle model
      await db.insert('Circle', {
        'name': event.circle.name,
        'school_id': event.circle.schoolId,
        'teacher_id': event.circle.teacherId,
        'description': event.circle.description,
        'circle_category_id': event.circle.circleCategoryId,
        'circle_type': event.circle.circleType,
        'circle_time': event.circle.circleTime,
        'created_at': now,
        'updated_at': now,
      });

      // Reload circles after adding
      add(LoadCircles(schoolId: event.circle.schoolId, teacherId: event.circle.teacherId));
    } catch (e) {
      emit(CircleError('Failed to add circle: $e'));
    }
  }

  Future<void> _onUpdateCircle(UpdateCircle event, Emitter<CircleState> emit) async {
    emit(CircleLoading());
    try {
      final db = await _databaseManager.database;
      final now = DateTime.now().toIso8601String();

      // Update the circle using the Circle model
      await db.update(
        'Circle',
        {
          ...event.circle.toMap(),
          'updated_at': now,
        },
        where: 'id = ?',
        whereArgs: [event.circle.id],
      );

      // Reload circles after updating
      add(LoadCircles(schoolId: event.circle.schoolId, teacherId: event.circle.teacherId));
    } catch (e) {
      emit(CircleError('Failed to update circle: $e'));
    }
  }

  Future<void> _onDeleteCircle(DeleteCircle event, Emitter<CircleState> emit) async {
    emit(CircleLoading());
    try {
      final db = await _databaseManager.database;
      final now = DateTime.now().toIso8601String();

      // Soft delete the circle
      await db.update(
        'Circle',
        {'deleted_at': now},
        where: 'id = ?',
        whereArgs: [event.circleId],
      );

      // Reload circles after deletion
      add(LoadCircles(teacherId: event.teacherId));
    } catch (e) {
      emit(CircleError('Failed to delete circle: $e'));
    }
  }
}