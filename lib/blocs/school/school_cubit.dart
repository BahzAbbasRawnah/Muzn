import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/school.dart';
import '../../services/database_service.dart';

part 'school_state.dart';

class SchoolCubit extends Cubit<SchoolState> {
  final DatabaseManager _databaseManager = DatabaseManager();
  List<School>? schoolsList;

  SchoolCubit() : super(SchoolInitial());

  Future<void> loadSchools(int teacherId) async {
    emit(SchoolLoading());
    try {
      final db = await _databaseManager.database;
      if (teacherId <= 0) {
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
      ''', [teacherId]);

      final schools = results.map((map) => School.fromMap(map)).toList();
      schoolsList = schools;
      emit(SchoolsLoaded(schools));
    } catch (e) {
      emit(SchoolError('Failed to load schools: $e'));
    }
  }

  Future<void> addSchool(String name, String? type, String? address, int teacherId) async {
    emit(SchoolLoading());
    try {
      final db = await _databaseManager.database;
      final now = DateTime.now().toIso8601String();

      await db.insert('School', {
        'name': name,
        'type': type,
        'address': address,
        'teacher_id': teacherId,
        'created_at': now,
        'updated_at': now,
      });

      await loadSchools(teacherId);
    } catch (e) {
      emit(SchoolError('Failed to add school: $e'));
    }
  }

  Future<void> updateSchool(School school) async {
    emit(SchoolLoading());
    try {
      final db = await _databaseManager.database;
      final now = DateTime.now().toIso8601String();

      await db.update(
        'School',
        {
          ...school.toMap(),
          'updated_at': now,
        },
        where: 'id = ?',
        whereArgs: [school.id],
      );

      await loadSchools(school.teacherId!);
    } catch (e) {
      emit(SchoolError('Failed to update school: $e'));
    }
  }

  Future<void> deleteSchool(int schoolId, int teacherId) async {
    emit(SchoolLoading());
    try {
      final db = await _databaseManager.database;
      final now = DateTime.now().toIso8601String();

      await db.update(
        'School',
        {'deleted_at': now},
        where: 'id = ?',
        whereArgs: [schoolId],
      );

      await loadSchools(teacherId);
    } catch (e) {
      emit(SchoolError('Failed to delete school: $e'));
    }
  }
}
