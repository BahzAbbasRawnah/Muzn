
// import 'package:muzn/models/student_model.dart';
// import 'package:muzn/services/local_database.dart';
// import 'package:muzn/utils/request_status.dart';

// class StudentController {
//   final DatabaseHelper _databaseHelper = DatabaseHelper();

//   // ================== Student Operations ==================

//   /// Add a new student
//   Future<RequestStatus> addStudent(Student student,int circleID) async {
//     int result=await _databaseHelper.insertStudent(student,circleID);
//     if(result>0){
//       return RequestStatus.success('Student added successfully');
//     }
//     return RequestStatus.failure('Failed to add student');
//   }

//   /// Fetch a student by their ID
//   Future<Map<String, dynamic>?> fetchStudentById(int id) async {
//     if (id <= 0) {
//       throw Exception("Invalid Student ID");
//     }
//     return await _databaseHelper.getStudentById(id);
//   }

//   /// Fetch all students
//   Future<List<Map<String, dynamic>>> fetchAllStudents() async {
//     return await _databaseHelper.getAllStudents();
//   }

//   /// Fetch all students assigned to a specific teacher
//   Future<List<Map<String, dynamic>>> fetchStudentsByTeacherId(int teacherId) async {
//     if (teacherId <= 0) {
//       throw Exception("Invalid Teacher ID");
//     }
//     return await _databaseHelper.getStudentsByTeacherId(teacherId);
//   }

//   /// Update an existing student
//   Future<int> editStudent(Map<String, dynamic> student) async {
//     if (student.isEmpty || !student.containsKey('id')) {
//       throw Exception("Invalid data for updating Student");
//     }
//     return await _databaseHelper.updateStudent(student);
//   }

//   /// Delete a student by their ID
//   Future<int> removeStudent(int id) async {
//     if (id <= 0) {
//       throw Exception("Invalid Student ID");
//     }
//     return await _databaseHelper.deleteStudent(id);
//   }

//     // ================== CircleStudent Operations ==================

//   /// Add a new circle student
//   Future<int> addCircleStudent(Map<String, dynamic> circleStudent) async {
//     if (circleStudent.isEmpty) {
//       throw Exception("CircleStudent data cannot be empty");
//     }
//     return await _databaseHelper.insertCircleStudent(circleStudent);
//   }

//   /// Fetch a circle With its student by circle ID
//   Future<Map<String, dynamic>?> fetchCircleWithStudentById(int circleId) async {
//    final circleData=await await _databaseHelper.getCircleWithStudentById(circleId);
//         print ("Circle Data: "+circleData.toString()); 
//             return circleData;


//   }

//   /// Fetch all circle students
//   Future<List<Map<String, dynamic>>> fetchAllCircleStudents() async {
//     return await _databaseHelper.getAllCircleStudents();
//   }

//   /// Update a circle student
//   Future<int> editCircleStudent(Map<String, dynamic> circleStudent) async {
//     if (circleStudent.isEmpty || !circleStudent.containsKey('id')) {
//       throw Exception("Invalid data for updating CircleStudent");
//     }
//     return await _databaseHelper.updateCircleStudent(circleStudent);
//   }

//   /// Delete a circle student by ID
//   Future<int> removeCircleStudent(int id) async {
//     if (id <= 0) {
//       throw Exception("Invalid CircleStudent ID");
//     }
//     return await _databaseHelper.deleteCircleStudent(id);
//   }
// }
