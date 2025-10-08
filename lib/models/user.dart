class UserModel {
  final String id;
  final String email;
  final String name;
  final String? profilePicture;
  final String? gender;
  final String? height;
  final String? weight;
  final String? age;
  final String? activityLevel;
  final String? goal;
  final String? targetWeight;
  final String? targetCalories;
  final String? targetProtein;
  final String? targetCarbs;
  final String? targetFats;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.profilePicture,
    required this.gender,
    required this.height,
    required this.weight,
    required this.age,
    required this.activityLevel,
    required this.goal,
    required this.targetWeight,
    required this.targetCalories,
    required this.targetProtein,
    required this.targetCarbs,
    required this.targetFats,
    required this.createdAt,
    required this.updatedAt,
  });

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    email: json['email'],
    name: json['name'],
    profilePicture: json['profilePicture'],
    gender: json['gender'],
    height: json['height'],
    weight: json['weight'],
    age: json['age'],
    activityLevel: json['activityLevel'],
    goal: json['goal'],
    targetWeight: json['targetWeight'],
    targetCalories: json['targetCalories'],
    targetProtein: json['targetProtein'],
    targetCarbs: json['targetCarbs'],
    targetFats: json['targetFats'],
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'profilePicture': profilePicture,
    'gender': gender,
    'height': height,
    'weight': weight,
    'age': age,
    'activityLevel': activityLevel,
    'goal': goal,
    'targetWeight': targetWeight,
    'targetCalories': targetCalories,
    'targetProtein': targetProtein,
    'targetCarbs': targetCarbs,
    'targetFats': targetFats,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
