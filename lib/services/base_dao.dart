import '../models/base_model.dart';

abstract class BaseDAO<T extends BaseModel> {
  Future<T?> getById(String id);
  Future<List<T>> getAll();
  Future<List<T>> getByUserId(String userId);
  Future<int> insert(T model);
  Future<int> update(T model);
  Future<int> delete(String id);
  Future<int> deleteByUserId(String userId);
}
