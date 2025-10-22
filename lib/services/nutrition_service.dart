import 'package:flutter/cupertino.dart';
import 'package:nutrition/models/meal.dart';
import 'package:nutrition/models/nutrition_log.dart';
import 'package:nutrition/models/workout.dart';
import 'package:nutrition/models/user.dart';
import 'app_database.dart';

class NutritionService {
  static final NutritionService _instance = NutritionService._internal();
  factory NutritionService() => _instance;
  NutritionService._internal();

  final AppDatabase _database = AppDatabase.instance;

  // User operations
  Future<UserModel?> getUser(String id) async {
    final userDAO = await _database.userDAO;
    return await userDAO.getById(id);
  }

  Future<int> saveUser(UserModel user) async {
    final userDAO = await _database.userDAO;
    final existing = await userDAO.getById(user.id);
    return existing != null
        ? await userDAO.update(user)
        : await userDAO.insert(user);
  }

  // Meal operations
  Future<List<Meal>> getUserMeals(String userId) async {
    final mealDAO = await _database.mealDAO;
    return await mealDAO.getByUserId(userId);
  }

  Future<List<Meal>> getMealsByType(String userId, String mealType) async {
    final mealDAO = await _database.mealDAO;
    return await mealDAO.getByMealType(userId, mealType);
  }

  Future<int> saveMeal(Meal meal) async {
    final mealDAO = await _database.mealDAO;
    final existing = await mealDAO.getById(meal.id);
    return existing != null
        ? await mealDAO.update(meal)
        : await mealDAO.insert(meal);
  }

  Future<int> deleteMeal(String mealId) async {
    final mealDAO = await _database.mealDAO;
    return await mealDAO.delete(mealId);
  }

  // Nutrition log operations
  Future<List<NutritionLog>> getUserNutritionLogs(String userId) async {
    final nutritionLogDAO = await _database.nutritionLogDAO;
    return await nutritionLogDAO.getByUserId(userId);
  }

  Future<NutritionLog?> getNutritionLogByDate(
    String userId,
    String date,
  ) async {
    final nutritionLogDAO = await _database.nutritionLogDAO;
    return await nutritionLogDAO.getByDate(userId, date);
  }

  Future<List<NutritionLog>> getNutritionLogsByDateRange(
    String userId,
    String startDate,
    String endDate,
  ) async {
    final nutritionLogDAO = await _database.nutritionLogDAO;
    return await nutritionLogDAO.getByDateRange(userId, startDate, endDate);
  }

  Future<int> createNutritionLog(String userId, String date) async {
    final nutritionLogDAO = await _database.nutritionLogDAO;
    return await nutritionLogDAO.insert(
      NutritionLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        date: date,
        totalCalories: 0,
        totalProtein: 0,
        totalCarbs: 0,
        totalFats: 0,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ),
    );
  }

  Future<int> saveNutritionLog(NutritionLog nutritionLog) async {
    final nutritionLogDAO = await _database.nutritionLogDAO;
    final existing = await nutritionLogDAO.getByDate(
      nutritionLog.userId,
      nutritionLog.date,
    );
    return existing != null
        ? await nutritionLogDAO.update(nutritionLog)
        : await nutritionLogDAO.insert(nutritionLog);
  }

  // Workout operations
  Future<List<Workout>> getUserWorkouts(String userId) async {
    final workoutDAO = await _database.workoutDAO;
    return await workoutDAO.getByUserId(userId);
  }

  Future<List<Workout>> getWorkoutsByType(
    String userId,
    String workoutType,
  ) async {
    final workoutDAO = await _database.workoutDAO;
    return await workoutDAO.getByWorkoutType(userId, workoutType);
  }

  Future<List<Workout>> getWorkoutsByDateRange(
    String userId,
    String startDate,
    String endDate,
  ) async {
    final workoutDAO = await _database.workoutDAO;
    return await workoutDAO.getByDateRange(userId, startDate, endDate);
  }

  Future<int> saveWorkout(Workout workout) async {
    final workoutDAO = await _database.workoutDAO;
    final existing = await workoutDAO.getById(workout.id);
    return existing != null
        ? await workoutDAO.update(workout)
        : await workoutDAO.insert(workout);
  }

  Future<int> deleteWorkout(String workoutId) async {
    final workoutDAO = await _database.workoutDAO;
    return await workoutDAO.delete(workoutId);
  }

  // Utility methods
  Future<void> closeDatabase() async {
    await _database.close();
  }
}
