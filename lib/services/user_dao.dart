import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import 'base_dao.dart';

class UserDAO implements BaseDAO<UserModel> {
  final Database _database;

  UserDAO(this._database);

  @override
  Future<UserModel?> getById(String id) async {
    final result = await _database.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? UserModel.fromJson(result.first) : null;
  }

  @override
  Future<List<UserModel>> getAll() async {
    final result = await _database.query('users');
    return result.map((e) => UserModel.fromJson(e)).toList();
  }

  @override
  Future<List<UserModel>> getByUserId(String userId) async {
    final result = await _database.query(
      'users',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return result.map((e) => UserModel.fromJson(e)).toList();
  }

  @override
  Future<int> insert(UserModel user) async {
    return await _database.insert('users', user.toJson());
  }

  @override
  Future<int> update(UserModel user) async {
    return await _database.update(
      'users',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  @override
  Future<int> delete(String id) async {
    return await _database.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<int> deleteByUserId(String userId) async {
    return await _database.delete(
      'users',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }
}
