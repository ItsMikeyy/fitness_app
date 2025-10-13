import 'package:sqflite/sqflite.dart';
import '../models/nutrition_log.dart';
import 'base_dao.dart';

class NutritionLogDAO implements BaseDAO<NutritionLog> {
  final Database _database;

  NutritionLogDAO(this._database);

  @override
  Future<NutritionLog?> getById(String id) async {
    final result = await _database.query(
      'nutrition_logs',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? NutritionLog.fromJson(result.first) : null;
  }

  @override
  Future<List<NutritionLog>> getAll() async {
    final result = await _database.query('nutrition_logs');
    return result.map((e) => NutritionLog.fromJson(e)).toList();
  }

  @override
  Future<List<NutritionLog>> getByUserId(String userId) async {
    final result = await _database.query(
      'nutrition_logs',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
    return result.map((e) => NutritionLog.fromJson(e)).toList();
  }

  Future<NutritionLog?> getByDate(String userId, String date) async {
    final result = await _database.query(
      'nutrition_logs',
      where: 'userId = ? AND date = ?',
      whereArgs: [userId, date],
    );
    return result.isNotEmpty ? NutritionLog.fromJson(result.first) : null;
  }

  Future<List<NutritionLog>> getByDateRange(
    String userId,
    String startDate,
    String endDate,
  ) async {
    final result = await _database.query(
      'nutrition_logs',
      where: 'userId = ? AND date BETWEEN ? AND ?',
      whereArgs: [userId, startDate, endDate],
      orderBy: 'date DESC',
    );
    return result.map((e) => NutritionLog.fromJson(e)).toList();
  }

  @override
  Future<int> insert(NutritionLog nutritionLog) async {
    return await _database.insert('nutrition_logs', nutritionLog.toJson());
  }

  @override
  Future<int> update(NutritionLog nutritionLog) async {
    return await _database.update(
      'nutrition_logs',
      nutritionLog.toJson(),
      where: 'id = ?',
      whereArgs: [nutritionLog.id],
    );
  }

  @override
  Future<int> delete(String id) async {
    return await _database.delete(
      'nutrition_logs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> deleteByUserId(String userId) async {
    return await _database.delete(
      'nutrition_logs',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }
}
