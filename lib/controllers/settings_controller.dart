// import 'package:muzn/services/local_database.dart';

// class AppController {
//   final DatabaseHelper _databaseHelper = DatabaseHelper();

//   // ================== DigitalLibrary Operations ==================

//   /// Add a new digital library item
//   Future<int> addDigitalLibraryItem(Map<String, dynamic> item) async {
//     if (item.isEmpty) {
//       throw Exception("DigitalLibrary item cannot be empty");
//     }
//     return await _databaseHelper.insertDigitalLibrary(item);
//   }

//   /// Fetch a digital library item by ID
//   Future<Map<String, dynamic>?> fetchDigitalLibraryItemById(int id) async {
//     if (id <= 0) {
//       throw Exception("Invalid DigitalLibrary ID");
//     }
//     return await _databaseHelper.getDigitalLibraryById(id);
//   }

//   /// Fetch all digital library items
//   Future<List<Map<String, dynamic>>> fetchAllDigitalLibraryItems() async {
//     return await _databaseHelper.getAllDigitalLibraryItems();
//   }

//   /// Update a digital library item
//   Future<int> updateDigitalLibraryItem(Map<String, dynamic> item) async {
//     if (item.isEmpty || !item.containsKey('id')) {
//       throw Exception("Invalid data for updating DigitalLibrary item");
//     }
//     return await _databaseHelper.updateDigitalLibrary(item);
//   }

//   /// Delete a digital library item by ID
//   Future<int> deleteDigitalLibraryItem(int id) async {
//     if (id <= 0) {
//       throw Exception("Invalid DigitalLibrary ID");
//     }
//     return await _databaseHelper.deleteDigitalLibrary(id);
//   }

//   // ================== Settings Operations ==================

//   /// Add a new settings record
//   Future<int> addSettings(Map<String, dynamic> settings) async {
//     if (settings.isEmpty) {
//       throw Exception("Settings data cannot be empty");
//     }
//     return await _databaseHelper.insertSettings(settings);
//   }

//   /// Fetch settings by ID
//   Future<Map<String, dynamic>?> fetchSettingsById(int id) async {
//     if (id <= 0) {
//       throw Exception("Invalid Settings ID");
//     }
//     return await _databaseHelper.getSettingsById(id);
//   }

//   /// Fetch all settings records
//   Future<List<Map<String, dynamic>>> fetchAllSettings() async {
//     return await _databaseHelper.getAllSettings();
//   }

//   /// Update settings
//   Future<int> updateSettings(Map<String, dynamic> settings) async {
//     if (settings.isEmpty || !settings.containsKey('id')) {
//       throw Exception("Invalid data for updating Settings");
//     }
//     return await _databaseHelper.updateSettings(settings);
//   }

//   /// Delete settings by ID
//   Future<int> deleteSettings(int id) async {
//     if (id <= 0) {
//       throw Exception("Invalid Settings ID");
//     }
//     return await _databaseHelper.deleteSettings(id);
//   }
// }
