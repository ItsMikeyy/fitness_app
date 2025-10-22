import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:nutrition/models/user.dart';
import 'user_dao.dart';
import 'meal_dao.dart';
import 'nutrition_log_dao.dart';
import 'workout_dao.dart';

const String databaseName = 'nutrition.db';
const int databaseVersion = 5;

class AppDatabase {
  AppDatabase._init();

  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  // DAO instances
  UserDAO? _userDAO;
  MealDAO? _mealDAO;
  NutritionLogDAO? _nutritionLogDAO;
  WorkoutDAO? _workoutDAO;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(databaseName);
    return _database!;
  }

  Future<Database> _initDB(String databaseName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, databaseName);
    return await openDatabase(
      path,
      version: databaseVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await _createUsersTable(db);
    await _createMealsTable(db);
    await _createNutritionLogsTable(db);
    await _createWorkoutsTable(db);
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add new tables for version 2
      await _createMealsTable(db);
      await _createNutritionLogsTable(db);
      await _createWorkoutsTable(db);
    }
    if (oldVersion < 3) {
      // Drop and recreate meals table for version 3 (schema changes)
      await db.execute('DROP TABLE IF EXISTS meals');
      await _createMealsTable(db);
    }
    if (oldVersion < 4) {
      // Add any changes for version 4
      // Currently no changes needed
    }
    if (oldVersion < 5) {
      // Add any changes for version 5
      // Example: Add a new column to users table
      // await db.execute('ALTER TABLE users ADD COLUMN newField TEXT');

      // Or recreate a table if needed
      // await db.execute('DROP TABLE IF EXISTS meals');
      // await _createMealsTable(db);
      await _createMealsTable(db);
      await _createNutritionLogsTable(db);
      await _createWorkoutsTable(db);

      print('Database upgraded from version $oldVersion to $newVersion');
    }
  }

  Future<void> _createUsersTable(Database db) async {
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

  Future<void> _createMealsTable(Database db) async {
    await db.execute('''
      CREATE TABLE meals (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        calories REAL NOT NULL,
        protein REAL NOT NULL,
        carbs REAL NOT NULL,
        fats REAL NOT NULL,
        mealType TEXT NOT NULL,
        imageUrl TEXT,
        servings INTEGER NOT NULL,
        notes TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');
  }

  Future<void> _createNutritionLogsTable(Database db) async {
    await db.execute('''
      CREATE TABLE nutrition_logs (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        date TEXT NOT NULL,
        totalCalories REAL NOT NULL,
        totalProtein REAL NOT NULL,
        totalCarbs REAL NOT NULL,
        totalFats REAL NOT NULL,
        notes TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id),
        UNIQUE(userId, date)
      )
    ''');
  }

  Future<void> _createWorkoutsTable(Database db) async {
    await db.execute('''
      CREATE TABLE workouts (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        workoutType TEXT NOT NULL,
        duration INTEGER NOT NULL,
        caloriesBurned REAL NOT NULL,
        difficulty TEXT NOT NULL,
        exercises TEXT NOT NULL,
        notes TEXT,
        workoutDate TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');
  }

  // DAO getters
  Future<UserDAO> get userDAO async {
    await database; // Ensure database is initialized
    _userDAO ??= UserDAO(_database!);
    return _userDAO!;
  }

  Future<MealDAO> get mealDAO async {
    await database; // Ensure database is initialized
    _mealDAO ??= MealDAO(_database!);
    return _mealDAO!;
  }

  Future<NutritionLogDAO> get nutritionLogDAO async {
    await database; // Ensure database is initialized
    _nutritionLogDAO ??= NutritionLogDAO(_database!);
    return _nutritionLogDAO!;
  }

  Future<WorkoutDAO> get workoutDAO async {
    await database; // Ensure database is initialized
    _workoutDAO ??= WorkoutDAO(_database!);
    return _workoutDAO!;
  }

  // Legacy methods for backward compatibility
  Future<UserModel?> getUser(String id) async {
    final userDAOInstance = await userDAO;
    return await userDAOInstance.getById(id);
  }

  Future<int> insertUser(UserModel user) async {
    final userDAOInstance = await userDAO;
    return await userDAOInstance.insert(user);
  }

  Future<int> updateUser(UserModel user) async {
    final userDAOInstance = await userDAO;
    return await userDAOInstance.update(user);
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
