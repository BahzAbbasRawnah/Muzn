import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/blocs/auth/auth_bloc.dart';
import 'package:path/path.dart';
import '../../models/school.dart';
import '../../services/database_service.dart';

// Events
abstract class SchoolEvent extends Equatable {
  final BuildContext context;
  
  const SchoolEvent(this.context);
  
  @override
  List<Object> get props => [context];
}

class LoadSchools extends SchoolEvent {
  const LoadSchools(BuildContext context) : super(context);
}

class AddSchool extends SchoolEvent {
  final String name;
  final String? type;
  final String? address;
  final int teacherId;

  const AddSchool({
    required BuildContext context,
    required this.name,
    this.type,
    this.address,
    required this.teacherId,
  }) : super(context);

  @override
  List<Object> get props => [name, teacherId, ...super.props];
}

class UpdateSchool extends SchoolEvent {
  final School school;

  const UpdateSchool(BuildContext context, this.school) : super(context);

  @override
  List<Object> get props => [school, ...super.props];
}

class DeleteSchool extends SchoolEvent {
  final int schoolId;

  const DeleteSchool(BuildContext context, this.schoolId) : super(context);

  @override
  List<Object> get props => [schoolId, ...super.props];
}

// States
abstract class SchoolState extends Equatable {
  @override
  List<Object> get props => [];
}

class SchoolInitial extends SchoolState {}

class SchoolLoading extends SchoolState {}

class SchoolsLoaded extends SchoolState {
  final List<School> schools;

  SchoolsLoaded(this.schools);

  @override
  List<Object> get props => [schools];
}

class SchoolError extends SchoolState {
  final String message;

  SchoolError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final DatabaseManager _databaseManager = DatabaseManager();

  SchoolBloc() : super(SchoolInitial()) {
    on<LoadSchools>(_onLoadSchools);
    on<AddSchool>(_onAddSchool);
    on<UpdateSchool>(_onUpdateSchool);
    on<DeleteSchool>(_onDeleteSchool);
  }

  Future<void> _onLoadSchools(LoadSchools event, Emitter<SchoolState> emit) async {
    emit(SchoolLoading());
    try {
      final db = await _databaseManager.database;
      
      // Get the current authenticated user
      final authState = event.context.read<AuthBloc>().state;
      if (authState is! AuthAuthenticated) {
        emit(SchoolError('not_authenticated'.tr(event.context)));
        return;
      }

      // Get schools with circle count for current user only
      final List<Map<String, dynamic>> results = await db.rawQuery('''
        SELECT s.*, COUNT(c.id) as circle_count 
        FROM School s 
        LEFT JOIN Circle c ON s.id = c.school_id AND c.deleted_at IS NULL
        WHERE s.deleted_at IS NULL 
        AND s.teacher_id = ?
        GROUP BY s.id
        ORDER BY s.created_at DESC
      ''', [authState.user.id]);

      final schools = results.map((map) => School.fromMap(map)).toList();
      emit(SchoolsLoaded(schools));
    } catch (e) {
      emit(SchoolError('failed_to_load_schools'));
    }
  }

  Future<void> _onAddSchool(AddSchool event, Emitter<SchoolState> emit) async {
    emit(SchoolLoading());
    try {
      final db = await _databaseManager.database;
      final now = DateTime.now().toIso8601String();

      await db.insert('School', {
        'name': event.name,
        'type': event.type,
        'address': event.address,
        'teacher_id': event.teacherId,
        'created_at': now,
        'updated_at': now,
      });

      // Get schools with circle count for current user only
      final List<Map<String, dynamic>> results = await db.rawQuery('''
        SELECT s.*, COUNT(c.id) as circle_count 
        FROM School s 
        LEFT JOIN Circle c ON s.id = c.school_id AND c.deleted_at IS NULL
        WHERE s.deleted_at IS NULL 
        AND s.teacher_id = ?
        GROUP BY s.id
        ORDER BY s.created_at DESC
      ''', [event.teacherId]);

      final schools = results.map((map) => School.fromMap(map)).toList();
      emit(SchoolsLoaded(schools));
    } catch (e) {
      emit(SchoolError('failed_to_add_school'));
    }
  }

  Future<void> _onUpdateSchool(UpdateSchool event, Emitter<SchoolState> emit) async {
    emit(SchoolLoading());
    try {
      final db = await _databaseManager.database;
      final now = DateTime.now().toIso8601String();

      await db.update(
        'School',
        {
          ...event.school.toMap(),
          'updated_at': now,
        },
        where: 'id = ?',
        whereArgs: [event.school.id],
      );

      add(LoadSchools(event.context));
    } catch (e) {
      emit(SchoolError('failed_to_update_school'));
    }
  }

  Future<void> _onDeleteSchool(DeleteSchool event, Emitter<SchoolState> emit) async {
    emit(SchoolLoading());
    try {
      final db = await _databaseManager.database;
      final now = DateTime.now().toIso8601String();

      await db.update(
        'School',
        {'deleted_at': now},
        where: 'id = ?',
        whereArgs: [event.schoolId],
      );

      add(LoadSchools(event.context));
    } catch (e) {
      emit(SchoolError('failed_to_delete_school'));
    }
  }
}
