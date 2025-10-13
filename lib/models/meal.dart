import 'base_model.dart';

class Meal implements BaseModel {
  @override
  final String id;
  final String userId;
  final String name;
  final String description;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final String mealType; // breakfast, lunch, dinner, snack
  final String? imageUrl;
  final int servings;
  final String? notes;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  Meal({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.mealType,
    this.imageUrl,
    required this.servings,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    id: json['id'],
    userId: json['userId'],
    name: json['name'],
    description: json['description'],
    calories: json['calories']?.toInt() ?? 0,
    protein: json['protein']?.toInt() ?? 0,
    carbs: json['carbs']?.toInt() ?? 0,
    fats: json['fats']?.toInt() ?? 0,
    mealType: json['mealType'],
    imageUrl: json['imageUrl'],
    servings: json['servings'] ?? 1,
    notes: json['notes'],
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'description': description,
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fats': fats,
    'mealType': mealType,
    'imageUrl': imageUrl,
    'servings': servings,
    'notes': notes,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  Meal copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    int? calories,
    int? protein,
    int? carbs,
    int? fats,
    String? mealType,
    String? imageUrl,
    int? servings,
    String? notes,
    String? createdAt,
    String? updatedAt,
  }) {
    return Meal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      mealType: mealType ?? this.mealType,
      imageUrl: imageUrl ?? this.imageUrl,
      servings: servings ?? this.servings,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
