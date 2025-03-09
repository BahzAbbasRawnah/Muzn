import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../services/database_service.dart';

class DatabaseSync {
  final DatabaseManager dbManager;

  DatabaseSync(this.dbManager);

  Future<void> syncDatabaseToAPI() async {
    final db = await dbManager.database;

    // List of tables to export
    List<String> tables = [
      'User', 'School', 'CirclesCategory', 'Circle', 'Student',
      'CircleStudent', 'StudentAttendance', 'Homework', 'StudentProgress',
      'DigitalLibrary', 'Settings'
    ];

    Map<String, dynamic> data = {};

    for (String table in tables) {
      List<Map<String, dynamic>> tableData = await db.query(table);
      data[table] = tableData;
    }

    String jsonData = jsonEncode(data);

    print("jsonData -----------------------------------------------");
    log(jsonData);
    // Replace with your API endpoint
    String apiUrl = "http://192.168.50.118:8000/api/sync";

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        print("Data synced successfully!");
      } else {
        print("Failed to sync data: ${response.body}");
      }
    } catch (e) {
      print("Error syncing data: $e");
    }
  }
}
