import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  static Database? _database;

  factory DatabaseManager() {
    return _instance;
  }

  DatabaseManager._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get the database path
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'app_database.db'); // Specify database file name

    // Open the database, creating it if it doesn't already exist
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create Users Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS User (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT NOT NULL,
        email TEXT UNIQUE,
        password TEXT NOT NULL,
        phone TEXT NOT NULL UNIQUE,
        country TEXT,
        gender TEXT CHECK(gender IN ('male', 'female')) NOT NULL,
        role TEXT CHECK(role IN ('admin', 'student', 'teacher')) NOT NULL,
        status TEXT CHECK(status IN ('active', 'inactive')) NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        deleted_at DATETIME
      )
    ''');

    // Create Schools Table
await db.execute('PRAGMA foreign_keys = ON');

await db.execute('''
  CREATE TABLE IF NOT EXISTS School (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    teacher_id INTEGER,
    name TEXT NOT NULL,
    type TEXT ,
    address TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME,
    FOREIGN KEY (teacher_id) REFERENCES User(id) ON DELETE CASCADE
  )
''');

// Set the autoincrement counter to start from 2
await db.execute("INSERT INTO sqlite_sequence (name, seq) VALUES ('School', 1)");


// Create CirclesCategory Table
await db.execute('''
  CREATE TABLE IF NOT EXISTS CirclesCategory (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    namevalue TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME
  )
''');

// Insert initial data into CirclesCategory
await db.insert('CirclesCategory', {'name': '  حفظ و مراجعة', 'namevalue': 'Listening'});
await db.insert('CirclesCategory', {'name': '  تحسين تلاوة و تجويد', 'namevalue': 'TajweedAndTelawah'});
await db.insert('CirclesCategory', {'name': ' تثبيت', 'namevalue': 'Tathbeet'});

// Ensure `updated_at` updates automatically on updates
await db.execute('''
  CREATE TRIGGER IF NOT EXISTS update_CirclesCategory_updated_at
  AFTER UPDATE ON CirclesCategory
  FOR EACH ROW
  BEGIN
    UPDATE CirclesCategory SET updated_at = CURRENT_TIMESTAMP WHERE id = OLD.id;
  END;
''');

    // Create Circle Table
    await db.execute('''
    CREATE TABLE IF NOT EXISTS Circle (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    school_id INTEGER,
    teacher_id INTEGER,
    name TEXT NOT NULL,
    description TEXT,
    circle_category_id INTEGER,
    circle_type TEXT NULL,
    circle_time TEXT NULL,
    jitsi_link TEXT,
    recording_url TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME,
    FOREIGN KEY (school_id) REFERENCES School(id),
    FOREIGN KEY (teacher_id) REFERENCES User(id),
    FOREIGN KEY (circle_category_id) REFERENCES CirclesCategory(id)
)
    ''');

    // Create Student Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Student (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        teacher_id INTEGER,
        user_id INTEGER,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        deleted_at DATETIME,
        FOREIGN KEY (user_id) REFERENCES User(id),
        FOREIGN KEY (teacher_id) REFERENCES User(id)
      )
    ''');

    // Create CircleStudent Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS CircleStudent (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        circle_id INTEGER,
        student_id INTEGER,
       teacher_id INTEGER,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        deleted_at DATETIME,
        FOREIGN KEY (circle_id) REFERENCES Circle(id),
        FOREIGN KEY (student_id) REFERENCES User(id),
        FOREIGN KEY (teacher_id) REFERENCES User(id)
      )
    ''');

        // Create CircleStudent Table
await db.execute('''
  CREATE TABLE IF NOT EXISTS StudentAttendance (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER,
    circle_id INTEGER,
    attendance_date DATETIME NOT NULL,
    status TEXT CHECK(status IN ('none', 'present', 'absent', 'absent_with_excuse', 'early_departure', 'not_listened', 'late')) DEFAULT 'none',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME,
    FOREIGN KEY (circle_id) REFERENCES Circle(id),
    FOREIGN KEY (student_id) REFERENCES User(id)
  )
''');


// Create Homework Table
await db.execute('''
  CREATE TABLE IF NOT EXISTS Homework (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    circle_id INTEGER,
    circle_category_id INTEGER,
    student_id INTEGER,
    start_surah_number INTEGER NOT NULL,
    end_surah_number INTEGER NOT NULL,
    start_ayah_number INTEGER NOT NULL,
    end_ayah_number INTEGER NOT NULL,
    homework_date DATETIME NOT NULL,
    checked INTEGER DEFAULT 0,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME,
    FOREIGN KEY (student_id) REFERENCES Student(id),
    FOREIGN KEY (circle_category_id) REFERENCES CirclesCategory(id)
    FOREIGN KEY (circle_id) REFERENCES Circle(id)

  )
''');

// Create StudentProgress Table
await db.execute('''
  CREATE TABLE IF NOT EXISTS StudentProgress (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    homework_id INTEGER,
    student_id INTEGER,
    reading_rating TEXT CHECK(reading_rating IN ('excellent', 'very_good', 'good', 'average', 'weak')) DEFAULT 'good',
    review_rating TEXT CHECK(review_rating IN ('excellent', 'very_good', 'good', 'average', 'weak')) DEFAULT 'good',
    telawah_rating TEXT CHECK(telawah_rating IN ('excellent', 'very_good', 'good', 'average', 'weak')) DEFAULT 'good',
    reading_wrong INTEGER DEFAULT 0,
    tajweed_wrong INTEGER DEFAULT 0,
    tashqeel_wrong INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME,
    FOREIGN KEY (homework_id) REFERENCES Homework(id),
    FOREIGN KEY (student_id) REFERENCES User(id)
  )
''');


    // Create DigitalLibrary Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS DigitalLibrary (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        author TEXT,
        category TEXT,
        file_url TEXT NOT NULL,
        teacher_id INTEGER,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        deleted_at DATETIME,
        FOREIGN KEY (teacher_id) REFERENCES User(id)
      )
    ''');

    // Create Settings Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        logo_url TEXT,
        address TEXT,
        phone TEXT,
        email TEXT,
        website_url TEXT,
        video_server_url TEXT,
        support_email TEXT,
        social_media_links TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        deleted_at DATETIME
      )
    ''');
  }

  Future<bool> doesTableExist(String tableName) async {
    final db = await database;
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'",
    );
    return result.isNotEmpty;
  }


}