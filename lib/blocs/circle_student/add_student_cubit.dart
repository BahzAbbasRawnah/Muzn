import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../services/database_service.dart';

part 'add_student_state.dart';

class AddStudentCubit extends Cubit<AddStudentState> {
  AddStudentCubit() : super(AddStudentInitial());

  Future<void> saveStudent({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String country,
    required String countryCode,
    required String gender,
    required int teacherId,
    required int circleId,
    // required DatabaseManager db,
  }) async {
    emit(AddStudentLoading());
    try {
      final db = await DatabaseManager().database;
      // Check if email or phone exists
      final List<Map<String, dynamic>> existingUser = await db.database.query(
        'User',
        where: '(email = ? OR phone = ?) AND deleted_at IS NULL',
        whereArgs: [email, phone],
      );

      if (existingUser.isNotEmpty) {
        emit(AddStudentError('Email or phone already exists.'));
        return;
      }

      await db.transaction((txn) async {
        // Insert into User table
        final userId = await txn.insert('User', {
          'full_name': fullName,
          'email': email,
          'password': password,
          'phone': phone,
          'country': country,
          'country_code': countryCode,
          'gender': gender,
          'role': 'student',
          'status': 'active',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });

        // Insert into Student table
        final studentId = await txn.insert('Student', {
          'user_id': userId,
          'teacher_id': teacherId,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });

        // Insert into CircleStudent table
        await txn.insert('CircleStudent', {
          'circle_id': circleId,
          'student_id': studentId,
          'teacher_id': teacherId,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      });

      emit(AddStudentSuccess());
    } catch (e) {
      emit(AddStudentError(e.toString()));
    }
  }
}
