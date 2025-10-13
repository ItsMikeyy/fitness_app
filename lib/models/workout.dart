import 'base_model.dart';

class Workout implements BaseModel {
  @override
  final String id;
  final String userId;
  final String name;
  final String description;
  final String workoutType; // cardio, strength, yoga, etc.
  final int duration; // in minutes
  final double caloriesBurned;
  final String difficulty; // beginner, intermediate, advanced
  final List<String> exercises; // JSON string of exercise list
  final String? notes;
  final String workoutDate; // YYYY-MM-DD format
  @override
  final String createdAt;
  @override
  final String updatedAt;

  Workout({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.workoutType,
    required this.duration,
    required this.caloriesBurned,
    required this.difficulty,
    required this.exercises,
    this.notes,
    required this.workoutDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
    id: json['id'],
    userId: json['userId'],
    name: json['name'],
    description: json['description'],
    workoutType: json['workoutType'],
    duration: json['duration'] ?? 0,
    caloriesBurned: json['caloriesBurned']?.toDouble() ?? 0.0,
    difficulty: json['difficulty'],
    exercises: json['exercises'] != null
        ? List<String>.from(json['exercises'].split(','))
        : [],
    notes: json['notes'],
    workoutDate: json['workoutDate'],
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'description': description,
    'workoutType': workoutType,
    'duration': duration,
    'caloriesBurned': caloriesBurned,
    'difficulty': difficulty,
    'exercises': exercises.join(','),
    'notes': notes,
    'workoutDate': workoutDate,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  Workout copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    String? workoutType,
    int? duration,
    double? caloriesBurned,
    String? difficulty,
    List<String>? exercises,
    String? notes,
    String? workoutDate,
    String? createdAt,
    String? updatedAt,
  }) {
    return Workout(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      workoutType: workoutType ?? this.workoutType,
      duration: duration ?? this.duration,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      difficulty: difficulty ?? this.difficulty,
      exercises: exercises ?? this.exercises,
      notes: notes ?? this.notes,
      workoutDate: workoutDate ?? this.workoutDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
