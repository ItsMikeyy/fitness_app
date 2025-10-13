import 'base_model.dart';

class NutritionLog implements BaseModel {
  @override
  final String id;
  final String userId;
  final String date; // YYYY-MM-DD format
  final int totalCalories;
  final int totalProtein;
  final int totalCarbs;
  final int totalFats;
  final String? notes;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  NutritionLog({
    required this.id,
    required this.userId,
    required this.date,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFats,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NutritionLog.fromJson(Map<String, dynamic> json) => NutritionLog(
    id: json['id'],
    userId: json['userId'],
    date: json['date'],
    totalCalories: json['totalCalories']?.toInt() ?? 0,
    totalProtein: json['totalProtein']?.toInt() ?? 0,
    totalCarbs: json['totalCarbs']?.toInt() ?? 0,
    totalFats: json['totalFats']?.toInt() ?? 0,
    notes: json['notes'],
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'date': date,
    'totalCalories': totalCalories,
    'totalProtein': totalProtein,
    'totalCarbs': totalCarbs,
    'totalFats': totalFats,
    'notes': notes,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  NutritionLog copyWith({
    String? id,
    String? userId,
    String? date,
    int? totalCalories,
    int? totalProtein,
    int? totalCarbs,
    int? totalFats,
    String? notes,
    String? createdAt,
    String? updatedAt,
  }) {
    return NutritionLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProtein: totalProtein ?? this.totalProtein,
      totalCarbs: totalCarbs ?? this.totalCarbs,
      totalFats: totalFats ?? this.totalFats,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
