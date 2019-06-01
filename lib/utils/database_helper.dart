import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:note_keeper/models/note.dart';
import 'dart:io';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;  // the singleton object
  static Database _database; // database singleton

  static String noteTable = 'note_table';
  static String colId = 'id';
  static String colTitle = 'title';
  static String colDescription = 'description';
  static String colPriority = 'priority';
  static String colDate = 'date';

  String dbCreateStatement = 'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, '
      '$colTitle  TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if(_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  // the function to create the database
  void _createDb(Database db, int newVersion) async {
    await db.execute(dbCreateStatement);
  }

  Future<Database> get database async {
    if(_database == null) {
      _database = await initDatabase();
    }
    return _database;
  }

  Future<Database> initDatabase() async {
    // get the directory path for both android and ios to store the database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    // open and create the database at the given path
    Database notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  Future<List<Map<String, dynamic>>>getNoteMapList() async {
    Database db = await this.database;
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    var result = await db.update(noteTable, note.toMap(), where: 'id = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    var result = await db.delete(noteTable, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT COUNT (*) FROM $noteTable');
    return Sqflite.firstIntValue(result);
  }

  Future<List<Note>> getNoteList() async {
    var map = await getNoteMapList();
    List<Note> list = map.map((note) {
      return Note.fromMap(note);
    }).toList();
    return list;
  }

}