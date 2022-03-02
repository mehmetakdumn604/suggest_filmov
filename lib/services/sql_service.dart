import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';
import 'package:suggest_filmov/const.dart';
import 'package:suggest_filmov/models/movie.dart';

class SqlService {
  static final SqlService instance = SqlService._init();
  static Database? _db;

  SqlService._init();

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }

    _db = await _initDB("watchlist.db");
    return _db!;
  }

  Future<Database> _initDB(String filePath) async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableName (
      sqlId INTEGER PRIMARY KEY AUTOINCREMENT,
      id INTEGER,
      backdrop_path TEXT, 
      original_language TEXT, 
      original_title TEXT, 
      overview TEXT,
      popularity TEXT,
      poster_path TEXT,
      release_date TEXT,
      title TEXT,
      vote_average TEXT,
      vote_count INTEGER,
      genre_ids TEXT
    )
''');

    await db.execute('''
    CREATE TABLE $favTable (
      sqlId INTEGER PRIMARY KEY AUTOINCREMENT,
      id INTEGER,
      backdrop_path TEXT, 
      original_language TEXT, 
      original_title TEXT, 
      overview TEXT,
      popularity TEXT,
      poster_path TEXT,
      release_date TEXT,
      title TEXT,
      vote_average TEXT,
      vote_count INTEGER,
      genre_ids TEXT
    )
''');
  }

  Future<Movie> insert(Movie movie, String table) async {
    final Database db = await instance.database;
    final int sqlId = await db.insert(table, movie.toJson());
    return movie.copy(sqlId: sqlId);
  }

  Future<List<Movie>> readAll(String table) async {
    final Database db = await instance.database;

    final maps = await db.query(table);

    if (maps.isNotEmpty) {
      return maps.map((e) => Movie.fromJson(e, fromSql: true)).toList();
    } else {
      return [];
    }
  }

  Future delete(int id, String table) async {
    try {
      final Database db = await instance.database;

      await db.rawDelete("DELETE FROM $table WHERE id = $id");
    } catch (e) {
      print(e.toString());
    }
  }

  Future close() async {
    final Database db = await instance.database;
    db.close();
  }
}
