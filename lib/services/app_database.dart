import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:nutrition/models/user.dart';

const String databaseName = 'nutrition.db';

class AppDatabase {
  AppDatabase._init();

  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(databaseName);
    return _database!;
  }

  Future<Database> _initDB(String databaseName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, databaseName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        name TEXT NOT NULL,
        profilePicture TEXT,
        gender TEXT,
        height TEXT,
        weight TEXT,
        age TEXT,
        activityLevel TEXT,
        goal TEXT,
        targetWeight TEXT,
        targetCalories TEXT,
        targetProtein TEXT,
        targetCarbs TEXT,
        targetFats TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  Future<UserModel?> getUser(String id) async {
    final db = await instance.database;
    final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
    print(result);
    return result.map((e) => UserModel.fromJson(e)).firstOrNull;
  }

  Future<int> insertUser(UserModel user) async {
    final db = await instance.database;
    return await db.insert('users', user.toJson());
  }

  Future<int> updateUser(UserModel user) async {
    final db = await instance.database;
    return await db.update(
      'users',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
