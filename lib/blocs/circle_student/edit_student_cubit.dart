import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:muzn/services/database_service.dart';

part 'edit_student_state.dart';

class EditStudentCubit extends Cubit<EditStudentState> {
  EditStudentCubit() : super(EditStudentInitial());

  Future<void> updateStudent({
    required int studentId,
    required String fullName,
    required String email,
    required String phone,
    required String country,
    required String gender,
  }) async {
    emit(EditStudentLoading());

    try {
      final db = await DatabaseManager().database;

      // Step 1: Fetch the user_id from the Student table using student_id
      final List<Map<String, dynamic>> studentResult = await db.query(
        'Student',
        where: 'id = ?',
        whereArgs: [studentId],
      );

      if (studentResult.isEmpty) {
        throw Exception('Student not found');
      }

      final int userId = studentResult.first['user_id'] as int;

      // Step 2: Check if email or phone exists for another user
      final List<Map<String, dynamic>> existingUser = await db.query(
        'User',
        where: '(email = ? OR phone = ?) AND id != ? AND deleted_at IS NULL',
        whereArgs: [email, phone, userId],
      );

      if (existingUser.isNotEmpty) {
        throw Exception('email_or_phone_exists');
      }

      // Step 3: Update the User table using the fetched user_id
      await db.transaction((txn) async {
        // Update User table
        await txn.update(
          'User',
          {
            'full_name': fullName,
            'email': email,
            'phone': phone,
            'country': country,
            'gender': gender,
            'updated_at': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [userId],
        );

        // Update Student table (if needed)
        await txn.update(
          'Student',
          {
            'updated_at': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [studentId],
        );
      });

      emit(EditStudentSuccess());
    } catch (e) {
      emit(EditStudentError(message: e.toString()));
    }
  }
}
