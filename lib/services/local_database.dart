// import 'package:muzn/models/student_model.dart';
// import 'package:muzn/models/user_model.dart';
// import 'package:muzn/services/database_service.dart';
// import 'package:muzn/utils/request_status.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//   final DatabaseManager _databaseHelper = DatabaseManager();

//   // ================== User Table Operations ==================

//   /// Insert a new user into the User table
//   Future<int> insertUser(Map<String, dynamic> user) async {
//     final db = await _databaseHelper.database;
//     return await db.insert('User', user,
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   /// Get a user by ID
//   Future<Map<String, dynamic>?> getUserById(int id) async {
//     final db = await _databaseHelper.database;
//     final result = await db.query('User', where: 'id = ?', whereArgs: [id]);
//     return result.isNotEmpty ? result.first : null;
//   }

//   /// Get all users
//   Future<List<Map<String, dynamic>>> getAllUsers() async {
//     final db = await _databaseHelper.database;
//     return await db.query('User');
//   }

//   /// Update a user
//   Future<int> updateUser(Map<String, dynamic> user) async {
//     final db = await _databaseHelper.database;
//     return await db
//         .update('User', user, where: 'id = ?', whereArgs: [user['id']]);
//   }

//   /// Delete a user by ID
//   Future<int> deleteUser(int id) async {
//     final db = await _databaseHelper.database;
//     return await db.delete('User', where: 'id = ?', whereArgs: [id]);
//   }

//   /// Get a user by email (for login purposes)
//   Future<Map<String, dynamic>?> getUserByEmail(String email) async {
//     final db = await _databaseHelper.database;
//     final result =
//         await db.query('User', where: 'email = ?', whereArgs: [email]);
//     return result.isNotEmpty ? result.first : null;
//   }

//   // ================== SchoolMosque Table Operations ==================

//   /// Insert a new school/mosque
//   Future<int> insertSchoolMosque(Map<String, dynamic> schoolMosque) async {
//     final db = await _databaseHelper.database;
//     return await db.insert('SchoolMosque', schoolMosque,
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   /// Get a school/mosque by ID
//   Future<Map<String, dynamic>?> getSchoolMosqueById(int id) async {
//     final db = await _databaseHelper.database;
//     final result =
//         await db.query('SchoolMosque', where: 'id = ?', whereArgs: [id]);
//     return result.isNotEmpty ? result.first : null;
//   }

//   /// Get all schools/mosques
//   Future<List<Map<String, dynamic>>> getAllSchoolMosques(
//       int teacher_user_id) async {
//     final db = await _databaseHelper.database;
//     return await db.query('SchoolMosque',
//         where: 'teacher_id = ?',
//         whereArgs: [teacher_user_id],
//         orderBy: 'created_at DESC');
//   }

//   /// Get all schools/mosques with the count of their circles
//   Future<List<Map<String, dynamic>>> getAllSchoolMosquesWithCirclesCount(
//       int teacherUserId) async {
//     final db = await _databaseHelper.database;

//     final List<Map<String, dynamic>> result = await db.rawQuery('''
//     SELECT 
//       sm.id, 
//       sm.teacher_id, 
//       sm.name, 
//       sm.type, 
//       sm.address, 
//       sm.created_at, 
//       sm.updated_at, 
//       sm.deleted_at,
//       COALESCE(COUNT(c.id), 0) AS circles_count
//     FROM SchoolMosque sm
//     LEFT JOIN Circle c ON sm.id = c.school_mosque_id
//     WHERE sm.teacher_id = ? OR sm.type = 'Virtual'
//     GROUP BY sm.id, sm.teacher_id, sm.name, sm.type, sm.address, sm.created_at, sm.updated_at, sm.deleted_at
//     ORDER BY sm.created_at DESC
//   ''', [teacherUserId]);

//     return result;
//   }

//   /// Update a school/mosque
//   Future<int> updateSchoolMosque(Map<String, dynamic> schoolMosque) async {
//     final db = await _databaseHelper.database;
//     return await db.update('SchoolMosque', schoolMosque,
//         where: 'id = ?', whereArgs: [schoolMosque['id']]);
//   }

//   /// Delete a school/mosque by ID
//   Future<int> deleteSchoolMosque(int id) async {
//     final db = await _databaseHelper.database;
//     return await db.delete('SchoolMosque', where: 'id = ?', whereArgs: [id]);
//   }

//   // ================== CirclesCategory Table Operations ==================

//   /// Insert a new circle category
//   Future<int> insertCirclesCategory(Map<String, dynamic> category) async {
//     final db = await _databaseHelper.database;
//     return await db.insert('CirclesCategory', category,
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   /// Get a circle category by ID
//   Future<Map<String, dynamic>?> getCirclesCategoryById(int id) async {
//     final db = await _databaseHelper.database;
//     final result =
//         await db.query('CirclesCategory', where: 'id = ?', whereArgs: [id]);
//     return result.isNotEmpty ? result.first : null;
//   }

//   /// Get all circle categories
//   Future<List<Map<String, dynamic>>> getAllCirclesCategories() async {
//     final db = await _databaseHelper.database;
//     return await db.query('CirclesCategory');
//   }

//   /// Update a circle category
//   Future<int> updateCirclesCategory(Map<String, dynamic> category) async {
//     final db = await _databaseHelper.database;
//     return await db.update('CirclesCategory', category,
//         where: 'id = ?', whereArgs: [category['id']]);
//   }

//   /// Delete a circle category by ID
//   Future<int> deleteCirclesCategory(int id) async {
//     final db = await _databaseHelper.database;
//     return await db.delete('CirclesCategory', where: 'id = ?', whereArgs: [id]);
//   }

//   // ================== Circle Table Operations ==================

//   /// Insert a new circle
//   Future<int> insertCircle(Map<String, dynamic> circle) async {
//     final db = await _databaseHelper.database;
//     return await db.insert('Circle', circle,
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   /// Get a circle by ID
//   Future<Map<String, dynamic>?> getCircleById(int id) async {
//     final db = await _databaseHelper.database;
//     final result = await db.query('Circle', where: 'id = ?', whereArgs: [id]);
//     return result.isNotEmpty ? result.first : null;
//   }

//   /// Get all circles
//   Future<List<Map<String, dynamic>>> getAllCircles() async {
//     final db = await _databaseHelper.database;
//     return await db.rawQuery('''
//     SELECT 
//       c.id,
//       c.name,
//       c.circle_type,
//       c.circle_time,
//       c.jitsi_link,
//       c.recording_url,
//       c.created_at,
//       c.updated_at,
//       cat.name AS category_name,
//       COUNT(cs.id) AS student_count
//     FROM Circle c
//     LEFT JOIN CirclesCategory cat ON c.circle_category_id = cat.id
//     LEFT JOIN CircleStudent cs ON c.id = cs.circle_id
//     GROUP BY c.id
//   ''');
//   }

//   /// Get all Mosque circles
//   Future<List<Map<String, dynamic>>> getAllMosqueCircles(int schoolId) async {
//     final db = await _databaseHelper.database;
//     return await db.rawQuery('''
//     SELECT 
//       c.id,
//       c.name,
//       c.circle_type,
//       c.circle_time,
//       c.jitsi_link,
//       c.recording_url,
//       c.created_at,
//       c.updated_at,
//       cat.name AS category_name,
//       COUNT(cs.id) AS student_count
//     FROM Circle c
//     LEFT JOIN CirclesCategory cat ON c.circle_category_id = cat.id
//     LEFT JOIN CircleStudent cs ON c.id = cs.circle_id
//     WHERE c.school_mosque_id = ?
//     GROUP BY c.id, c.name, c.circle_type, c.circle_time, c.jitsi_link, 
//              c.recording_url, c.created_at, c.updated_at, cat.name;
//   ''', [schoolId]);
//   }

//   /// Update a circle
//   Future<int> updateCircle(Map<String, dynamic> circle) async {
//     final db = await _databaseHelper.database;
//     return await db
//         .update('Circle', circle, where: 'id = ?', whereArgs: [circle['id']]);
//   }

//   /// Delete a circle by ID
//   Future<int> deleteCircle(int id) async {
//     final db = await _databaseHelper.database;
//     return await db.delete('Circle', where: 'id = ?', whereArgs: [id]);
//   }

//   // ================== Student Table Operations ==================

//   /// Insert a new student
//   Future<int> insertStudent(Student student, int circleID) async {
//     final db = await _databaseHelper.database;
//         int result = 0;

//     try {
//       // Use a transaction to ensure atomicity
//       await db.transaction((txn) async {
//         // Insert the User record
//         int createdUserID = await txn.insert(
//           'User',
//           student.user.toMap(),
//           conflictAlgorithm: ConflictAlgorithm.replace,
//         );
//         print('User Student created successfully');
//         // Insert the Student record
//         int createdStudentID = await txn.rawInsert(
//           'INSERT INTO Student (user_id, teacher_id) VALUES (?, ?)',
//           [createdUserID, student.teacherId],
//         );
//         print(' Student created successfully');
//         // Insert the CircleStudent record
//         result = await txn.insert(
//           'CircleStudent',
//           {
//             'circle_id': circleID,
//             'student_id': createdStudentID,
//             'teacher_id': student.teacherId
//           },
//           conflictAlgorithm: ConflictAlgorithm.replace,
//         );
//         print('CircleStudent created successfully');
//       });

//       // If everything succeeds, return success
//       return result;
//     } catch (e) {
//       // If any error occurs, return failure
//       return 0;
//     }
//   }

//   /// Get a student by ID
//   Future<Map<String, dynamic>?> getStudentById(int id) async {
//     final db = await _databaseHelper.database;
//     final result = await db.query('Student', where: 'id = ?', whereArgs: [id]);
//     return result.isNotEmpty ? result.first : null;
//   }

//   /// Get all students
//   Future<List<Map<String, dynamic>>> getAllStudents() async {
//     final db = await _databaseHelper.database;
//     return await db.query('Student');
//   }

//   /// Get all students by teacher ID
//   Future<List<Map<String, dynamic>>> getStudentsByTeacherId(
//       int teacherId) async {
//     final db = await _databaseHelper.database;
//     return await db
//         .query('Student', where: 'teacher_id = ?', whereArgs: [teacherId]);
//   }

//   /// Update a student
//   Future<int> updateStudent(Map<String, dynamic> student) async {
//     final db = await _databaseHelper.database;
//     return await db.update('Student', student,
//         where: 'id = ?', whereArgs: [student['id']]);
//   }

//   /// Delete a student by ID
//   Future<int> deleteStudent(int id) async {
//     final db = await _databaseHelper.database;
//     return await db.delete('Student', where: 'id = ?', whereArgs: [id]);
//   }

//   // ================== CircleStudent Table Operations ==================

//   /// Insert a new circle student
//   Future<int> insertCircleStudent(Map<String, dynamic> circleStudent) async {
//     final db = await _databaseHelper.database;
//     return await db.insert('CircleStudent', circleStudent,
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   /// Get a circle with all its student by ID
//   Future<Map<String, dynamic>?> getCircleWithStudentById(int circleId) async {
//     final db = await _databaseHelper.database;

//     final result = await db.rawQuery('''
//     SELECT 
//       c.id AS circle_id,
//       c.name AS circle_name,
//       c.circle_type,
//       c.circle_time,
//       c.jitsi_link,
//       c.recording_url,
//       us.id AS student_id,
//       us.full_name AS student_name,
//       us.email AS student_email,
//       us.phone AS student_phone,
//       us.gender AS student_gender,
//       us.status AS student_status,
//       st.id AS student_table_id,
//       st.teacher_id AS student_teacher_id,
//       st.created_at AS student_created_at
//     FROM Circle c
//     LEFT JOIN CircleStudent cs ON c.id = cs.circle_id
//     LEFT JOIN Student st ON cs.student_id = st.id
//     LEFT JOIN User us ON st.user_id = us.id
//     WHERE c.id = ?
//   ''', [circleId]);

//     if (result.isNotEmpty) {
//       final circleData = {
//         "circle_id": result.first["circle_id"],
//         "circle_name": result.first["circle_name"],
//         "circle_type": result.first["circle_type"],
//         "circle_time": result.first["circle_time"],
//         "jitsi_link": result.first["jitsi_link"],
//         "recording_url": result.first["recording_url"],
//         "students": result
//             .map((row) => {
//                   "student_id": row["student_id"],
//                   "student_name": row["student_name"],
//                   "student_email": row["student_email"],
//                   "student_phone": row["student_phone"],
//                   "student_gender": row["student_gender"],
//                   "student_status": row["student_status"],
//                   "student_table_id": row["student_table_id"],
//                   "student_teacher_id": row["student_teacher_id"],
//                   "student_created_at": row["student_created_at"],
//                 })
//             .where((student) => student["student_id"] != null)
//             .toList(),
//       };

//       return circleData;
//     }

//     return null;
//   }

//   /// Get all circle students
//   Future<List<Map<String, dynamic>>> getAllCircleStudents() async {
//     final db = await _databaseHelper.database;
//     return await db.query('CircleStudent');
//   }

//   /// Update a circle student
//   Future<int> updateCircleStudent(Map<String, dynamic> circleStudent) async {
//     final db = await _databaseHelper.database;
//     return await db.update('CircleStudent', circleStudent,
//         where: 'id = ?', whereArgs: [circleStudent['id']]);
//   }

//   /// Delete a circle student by ID
//   Future<int> deleteCircleStudent(int id) async {
//     final db = await _databaseHelper.database;
//     return await db.delete('CircleStudent', where: 'id = ?', whereArgs: [id]);
//   }

//   // ================== StudentProgress Table Operations ==================

//   /// Insert a new student progress
//   Future<int> insertStudentProgress(Map<String, dynamic> progress) async {
//     final db = await _databaseHelper.database;
//     return await db.insert('StudentProgress', progress,
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   /// Get a student progress by ID
//   Future<Map<String, dynamic>?> getStudentProgressById(int id) async {
//     final db = await _databaseHelper.database;
//     final result =
//         await db.query('StudentProgress', where: 'id = ?', whereArgs: [id]);
//     return result.isNotEmpty ? result.first : null;
//   }

//   /// Get all student progress records
//   Future<List<Map<String, dynamic>>> getAllStudentProgress() async {
//     final db = await _databaseHelper.database;
//     return await db.query('StudentProgress');
//   }

//   /// Update a student progress
//   Future<int> updateStudentProgress(Map<String, dynamic> progress) async {
//     final db = await _databaseHelper.database;
//     return await db.update('StudentProgress', progress,
//         where: 'id = ?', whereArgs: [progress['id']]);
//   }

//   /// Delete a student progress by ID
//   Future<int> deleteStudentProgress(int id) async {
//     final db = await _databaseHelper.database;
//     return await db.delete('StudentProgress', where: 'id = ?', whereArgs: [id]);
//   }

//   // ================== HomeWork Table Operations ==================

//   /// Insert a new homework
//   Future<int> insertHomeWork(Map<String, dynamic> homework) async {
//     final db = await _databaseHelper.database;
//     return await db.insert('HomeWork', homework,
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   /// Get an homework by ID
//   Future<Map<String, dynamic>?> getHomeWorkById(int id) async {
//     final db = await _databaseHelper.database;
//     final result = await db.query('HomeWork', where: 'id = ?', whereArgs: [id]);
//     return result.isNotEmpty ? result.first : null;
//   }

//   /// Get all homeworks
//   Future<List<Map<String, dynamic>>> getAllHomeWorks() async {
//     final db = await _databaseHelper.database;
//     return await db.query('HomeWork');
//   }

//   /// Update an homework
//   Future<int> updateHomeWork(Map<String, dynamic> homework) async {
//     final db = await _databaseHelper.database;
//     return await db.update('HomeWork', homework,
//         where: 'id = ?', whereArgs: [homework['id']]);
//   }

//   /// Delete an homework by ID
//   Future<int> deleteHomeWork(int id) async {
//     final db = await _databaseHelper.database;
//     return await db.delete('HomeWork', where: 'id = ?', whereArgs: [id]);
//   }

//   // ================== DigitalLibrary Table Operations ==================

//   /// Insert a new digital library item
//   Future<int> insertDigitalLibrary(Map<String, dynamic> item) async {
//     final db = await _databaseHelper.database;
//     return await db.insert('DigitalLibrary', item,
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   /// Get a digital library item by ID
//   Future<Map<String, dynamic>?> getDigitalLibraryById(int id) async {
//     final db = await _databaseHelper.database;
//     final result =
//         await db.query('DigitalLibrary', where: 'id = ?', whereArgs: [id]);
//     return result.isNotEmpty ? result.first : null;
//   }

//   /// Get all digital library items
//   Future<List<Map<String, dynamic>>> getAllDigitalLibraryItems() async {
//     final db = await _databaseHelper.database;
//     return await db.query('DigitalLibrary');
//   }

//   /// Update a digital library item
//   Future<int> updateDigitalLibrary(Map<String, dynamic> item) async {
//     final db = await _databaseHelper.database;
//     return await db.update('DigitalLibrary', item,
//         where: 'id = ?', whereArgs: [item['id']]);
//   }

//   /// Delete a digital library item by ID
//   Future<int> deleteDigitalLibrary(int id) async {
//     final db = await _databaseHelper.database;
//     return await db.delete('DigitalLibrary', where: 'id = ?', whereArgs: [id]);
//   }

//   // ================== Settings Table Operations ==================

//   /// Insert a new settings record
//   Future<int> insertSettings(Map<String, dynamic> settings) async {
//     final db = await _databaseHelper.database;
//     return await db.insert('Settings', settings,
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   /// Get settings by ID
//   Future<Map<String, dynamic>?> getSettingsById(int id) async {
//     final db = await _databaseHelper.database;
//     final result = await db.query('Settings', where: 'id = ?', whereArgs: [id]);
//     return result.isNotEmpty ? result.first : null;
//   }

//   /// Get all settings records
//   Future<List<Map<String, dynamic>>> getAllSettings() async {
//     final db = await _databaseHelper.database;
//     return await db.query('Settings');
//   }

//   /// Update settings
//   Future<int> updateSettings(Map<String, dynamic> settings) async {
//     final db = await _databaseHelper.database;
//     return await db.update('Settings', settings,
//         where: 'id = ?', whereArgs: [settings['id']]);
//   }

//   /// Delete settings by ID
//   Future<int> deleteSettings(int id) async {
//     final db = await _databaseHelper.database;
//     return await db.delete('Settings', where: 'id = ?', whereArgs: [id]);
//   }
// }
