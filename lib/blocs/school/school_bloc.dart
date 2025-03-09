import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../api/database_sync.dart';
import '../../models/school.dart';
import '../../services/database_service.dart';

// Events
abstract class SchoolEvent extends Equatable {
  const SchoolEvent();
  
  @override
  List<Object> get props => [];
}

class LoadSchools extends SchoolEvent {
  final int teacherId;
  const LoadSchools(this.teacherId);

  @override
  List<Object> get props => [teacherId];
}

class AddSchool extends SchoolEvent {
  final String name;
  final String? type;
  final String? address;
  final int teacherId;
  final String teacherUuid;

  const AddSchool({
    required this.name,
    this.type,
    this.address,
    required this.teacherId,
    required this.teacherUuid,
  });

  @override
  List<Object> get props => [name, teacherId, ...super.props];
}

class UpdateSchool extends SchoolEvent {
  final School school;

  const UpdateSchool(this.school);

  @override
  List<Object> get props => [school, ...super.props];
}

class DeleteSchool extends SchoolEvent {
  final int schoolId;
  int teacherId;

   DeleteSchool(this.schoolId,this.teacherId);

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
  List<School>? schoolsList;
  SchoolBloc() : super(SchoolInitial()) {
    on<LoadSchools>(_onLoadSchools);
    on<AddSchool>(_onAddSchool);
    on<UpdateSchool>(_onUpdateSchool);
    on<DeleteSchool>(_onDeleteSchool);
  }

  Future<void> _onLoadSchools(LoadSchools event, Emitter<SchoolState> emit) async {
    emit(SchoolLoading());
    final DatabaseSync databaseSync = DatabaseSync(DatabaseManager());
    databaseSync.syncDatabaseToAPI();

    try {
      final db = await _databaseManager.database;
      if (event.teacherId <= 0) {
        emit(SchoolError('Invalid teacher ID.'));
        return;
      }


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
      schoolsList=schools;
      emit(SchoolsLoaded(schools));
    } catch (e) {
      emit(SchoolError('Failed to load schools: $e'));
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
        'teacher_uuid': event.teacherUuid,
        'created_at': now,
        'updated_at': now,
      });

      add(LoadSchools(event.teacherId));
    } catch (e) {
      emit(SchoolError('Failed to add school: $e'));
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

      add(LoadSchools(event.school.teacherId!));
    } catch (e) {
      emit(SchoolError('Failed to update school: $e'));
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

      add(LoadSchools(event.teacherId));
    } catch (e) {
      emit(SchoolError('Failed to delete school: $e'));
    }
  }
}