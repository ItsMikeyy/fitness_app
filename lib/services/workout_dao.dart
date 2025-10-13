import 'package:sqflite/sqflite.dart';
import '../models/workout.dart';
import 'base_dao.dart';

class WorkoutDAO implements BaseDAO<Workout> {
  final Database _database;

  WorkoutDAO(this._database);

  @override
  Future<Workout?> getById(String id) async {
    final result = await _database.query(
      'workouts',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? Workout.fromJson(result.first) : null;
  }

  @override
  Future<List<Workout>> getAll() async {
    final result = await _database.query('workouts');
    return result.map((e) => Workout.fromJson(e)).toList();
  }

  @override
  Future<List<Workout>> getByUserId(String userId) async {
    final result = await _database.query(
      'workouts',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'workoutDate DESC',
    );
    return result.map((e) => Workout.fromJson(e)).toList();
  }

  Future<List<Workout>> getByWorkoutType(
    String userId,
    String workoutType,
  ) async {
    final result = await _database.query(
      'workouts',
      where: 'userId = ? AND workoutType = ?',
      whereArgs: [userId, workoutType],
      orderBy: 'workoutDate DESC',
    );
    return result.map((e) => Workout.fromJson(e)).toList();
  }

  Future<List<Workout>> getByDateRange(
    String userId,
    String startDate,
    String endDate,
  ) async {
    final result = await _database.query(
      'workouts',
      where: 'userId = ? AND workoutDate BETWEEN ? AND ?',
      whereArgs: [userId, startDate, endDate],
      orderBy: 'workoutDate DESC',
    );
    return result.map((e) => Workout.fromJson(e)).toList();
  }

  @override
  Future<int> insert(Workout workout) async {
    return await _database.insert('workouts', workout.toJson());
  }

  @override
  Future<int> update(Workout workout) async {
    return await _database.update(
      'workouts',
      workout.toJson(),
      where: 'id = ?',
      whereArgs: [workout.id],
    );
  }

  @override
  Future<int> delete(String id) async {
    return await _database.delete('workouts', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<int> deleteByUserId(String userId) async {
    return await _database.delete(
      'workouts',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }
}
