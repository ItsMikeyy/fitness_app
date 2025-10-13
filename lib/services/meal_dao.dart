import 'package:sqflite/sqflite.dart';
import '../models/meal.dart';
import 'base_dao.dart';

class MealDAO implements BaseDAO<Meal> {
  final Database _database;

  MealDAO(this._database);

  @override
  Future<Meal?> getById(String id) async {
    final result = await _database.query(
      'meals',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? Meal.fromJson(result.first) : null;
  }

  @override
  Future<List<Meal>> getAll() async {
    final result = await _database.query('meals');
    return result.map((e) => Meal.fromJson(e)).toList();
  }

  @override
  Future<List<Meal>> getByUserId(String userId) async {
    final result = await _database.query(
      'meals',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
    );
    return result.map((e) => Meal.fromJson(e)).toList();
  }

  Future<List<Meal>> getByMealType(String userId, String mealType) async {
    final result = await _database.query(
      'meals',
      where: 'userId = ? AND mealType = ?',
      whereArgs: [userId, mealType],
      orderBy: 'createdAt DESC',
    );
    return result.map((e) => Meal.fromJson(e)).toList();
  }

  @override
  Future<int> insert(Meal meal) async {
    return await _database.insert('meals', meal.toJson());
  }

  @override
  Future<int> update(Meal meal) async {
    return await _database.update(
      'meals',
      meal.toJson(),
      where: 'id = ?',
      whereArgs: [meal.id],
    );
  }

  @override
  Future<int> delete(String id) async {
    return await _database.delete('meals', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<int> deleteByUserId(String userId) async {
    return await _database.delete(
      'meals',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }
}
