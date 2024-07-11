import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Initialize the database without using path package
    var databasesPath = await getDatabasesPath();
    String path = "$databasesPath/kajak.db";
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE kawruh_basa ('
          'id INTEGER PRIMARY KEY, '
          'javanese TEXT, '
          'aranan TEXT, '
          'indonesian TEXT, '
          'image TEXT, '
          'type INTEGER, '
          'created_at TEXT, '
          'updated_at TEXT, '
          'parent_id INTEGER, '
          'is_open INTEGER'
          ')',
        );
        await db.execute(
          'CREATE TABLE paramasastra ('
              'id INTEGER PRIMARY KEY, '
              'name TEXT, '
              'description TEXT, '
              'parent_id INTEGER, '
              'created_at TEXT, '
              'updated_at TEXT, '
              'is_open INTEGER'
              ')',
        );
        await db.execute(
          'CREATE TABLE paribasan ('
          'id INTEGER PRIMARY KEY, '
          'paribasan TEXT, '
          'meaning_in_java TEXT, '
          'meaning_in_indo TEXT, '
          'created_at TEXT, '
          'updated_at TEXT'
          ')',
        );
        await db.execute(
          'CREATE TABLE tembang ('
          'id INTEGER PRIMARY KEY, '
          'name TEXT, '
          'subtitle TEXT, '
          'image TEXT, '
          'description TEXT, '
          'parent_id INTEGER, '
          'created_at TEXT, '
          'updated_at TEXT, '
          'FOREIGN KEY (parent_id) REFERENCES tembang (id)'
          ')',
        );
        await db.execute(
          'CREATE TABLE parikan ('
          'id INTEGER PRIMARY KEY, '
          'parikan TEXT, '
          'meaning_in_java TEXT, '
          'meaning_in_indo TEXT, '
          'created_at TEXT, '
          'updated_at TEXT'
          ')',
        );
        await db.execute(
          'CREATE TABLE exam_results ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'status INTEGER, '
          'message TEXT, '
          'attempt_id INTEGER, '
          'exam_id INTEGER, '
          'started_at TEXT, '
          'finished_at TEXT, '
          'score INTEGER, '
          'created_at TEXT, '
          'updated_at TEXT, '
          'deleted_at TEXT, '
          'user_id INTEGER, '
          'password TEXT'
          ')',
        );
        await db.execute(
          'CREATE TABLE questions ('
          'id INTEGER PRIMARY KEY, '
          'page TEXT, '
          'exam_id INTEGER, '
          'question TEXT, '
          'explanation TEXT, '
          'created_at TEXT, '
          'updated_at TEXT'
          ')',
        );
        await db.execute(
          'CREATE TABLE answers ('
          'id INTEGER PRIMARY KEY, '
          'question_id INTEGER, '
          'answer TEXT, '
          'is_correct INTEGER, '
          'created_at TEXT, '
          'updated_at TEXT, '
          'FOREIGN KEY (question_id) REFERENCES questions(id)'
          ')',
        );
        await db.execute(
          'CREATE TABLE current_answer ('
          'id INTEGER PRIMARY KEY, '
          'question_id INTEGER, '
          'answer TEXT, '
          'is_correct INTEGER, '
          'created_at TEXT, '
          'updated_at TEXT, '
          'FOREIGN KEY (question_id) REFERENCES questions(id)'
          ')',
        );
        await db.execute(
          'CREATE TABLE send_answer ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'question_id INTEGER, '
          'answer_id INTEGER, '
          'attempt_id INTEGER, '
          'is_send INTEGER'
          ')',
        );
      },
    );
  }
}
