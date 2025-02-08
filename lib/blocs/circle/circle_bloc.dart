import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muzn/blocs/auth/auth_bloc.dart';
import '../../models/circle.dart';
import '../../services/database_service.dart';

// Events
abstract class CircleEvent extends Equatable {
  final BuildContext context;
  
  const CircleEvent(this.context);
  
  @override
  List<Object> get props => [context];
}

class LoadCircles extends CircleEvent {
  final int? schoolId;
  
  const LoadCircles(BuildContext context, {this.schoolId}) : super(context);
  
  @override
  List<Object> get props => [context, if (schoolId != null) schoolId!];
}

class AddCircle extends CircleEvent {
  final String name;
  final int? schoolId;
  final int teacherId;
  final String? description;
  final int? circleCategoryId;
  final String? circleType;
  final String? circleTime;

  const AddCircle({
    required BuildContext context,
    required this.name,
    this.schoolId,
    required this.teacherId,
    this.description,
    this.circleCategoryId,
    this.circleType,
    this.circleTime,
  }) : super(context);

  @override
  List<Object> get props => [context, name, teacherId];
}

class UpdateCircle extends CircleEvent {
  final Circle circle;

  const UpdateCircle(BuildContext context, this.circle) : super(context);

  @override
  List<Object> get props => [context, circle];
}

class DeleteCircle extends CircleEvent {
  final int circleId;

  const DeleteCircle(BuildContext context, this.circleId) : super(context);

  @override
  List<Object> get props => [context, circleId];
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
      final List<Map<String, dynamic>> results = await db.rawQuery('''
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
        AND c.teacher_id = ?
        ${event.schoolId != null ? 'AND c.school_id = ?' : ''}
        GROUP BY c.id
        ORDER BY c.created_at DESC
      ''', [
        event.context.read<AuthBloc>().state is AuthAuthenticated 
            ? (event.context.read<AuthBloc>().state as AuthAuthenticated).user.id 
            : -1,
        if (event.schoolId != null) event.schoolId,
      ]);

      final circles = results.map((map) => Circle.fromMap(map)).toList();
      emit(CirclesLoaded(circles));
    } catch (e) {
      emit(const CircleError('failed_to_load_circles'));
    }
  }

  Future<void> _onAddCircle(AddCircle event, Emitter<CircleState> emit) async {
    emit(CircleLoading());
    try {
      final db = await _databaseManager.database;
      final now = DateTime.now().toIso8601String();

      await db.insert('Circle', {
        'name': event.name,
        'school_id': event.schoolId,
        'teacher_id': event.teacherId,
        'description': event.description,
        'circle_category_id': event.circleCategoryId,
        'circle_type': event.circleType,
        'circle_time': event.circleTime,
        'created_at': now,
        'updated_at': now,
      });

      add(LoadCircles(event.context, schoolId: event.schoolId));
    } catch (e) {
      emit(const CircleError('failed_to_add_circle'));
    }
  }

  Future<void> _onUpdateCircle(UpdateCircle event, Emitter<CircleState> emit) async {
    emit(CircleLoading());
    try {
      final db = await _databaseManager.database;
      final now = DateTime.now().toIso8601String();

      await db.update(
        'Circle',
        {
          'name': event.circle.name,
          'school_id': event.circle.schoolId,
          'description': event.circle.description,
          'circle_category_id': event.circle.circleCategoryId,
          'circle_type': event.circle.circleType,
          'circle_time': event.circle.circleTime,
          'updated_at': now,
        },
        where: 'id = ?',
        whereArgs: [event.circle.id],
      );

      add(LoadCircles(event.context, schoolId: event.circle.schoolId));
    } catch (e) {
      emit(const CircleError('failed_to_update_circle'));
    }
  }

  Future<void> _onDeleteCircle(DeleteCircle event, Emitter<CircleState> emit) async {
    emit(CircleLoading());
    try {
      final db = await _databaseManager.database;
      final now = DateTime.now().toIso8601String();

      await db.update(
        'Circle',
        {'deleted_at': now},
        where: 'id = ?',
        whereArgs: [event.circleId],
      );

      add(LoadCircles(event.context));
    } catch (e) {
      emit(const CircleError('failed_to_delete_circle'));
    }
  }
}
