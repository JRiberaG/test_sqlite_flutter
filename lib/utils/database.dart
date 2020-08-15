import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:async';

import 'package:test_sqlite/models/dog.dart';

class DbHelper {

  DbHelper._();
  static final DbHelper db = DbHelper._();
  static Database _database;

  // Gets the database or makes a new one
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  // Initializes the Database
  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'dogs.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE dogs (
            id INTEGER PRIMARY KEY, name TEXT, age INTEGER
          )
        ''');
      },
      version: 1
    );
  }

  // Method to insert the dog
  Future<void> insertDog(Dog dog) async {
    final db = await database;

    await db.insert('dogs',
        dog.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Method to retrieve (as a list of Dogs) all the dogs in the database
  Future<List<Dog>> getDogs() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('dogs');

    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age']
      );
    });
  }

  // Method to delete all the dogs in the database
  Future<void> deleteDogs() async {
    final db = await database;

    db.delete('dogs');
  }
}