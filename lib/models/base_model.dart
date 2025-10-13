abstract class BaseModel {
  String get id;
  String get createdAt;
  String get updatedAt;

  Map<String, dynamic> toJson();
}
