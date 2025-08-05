import '../../domain/entites/category_type.dart';

class CategoryTypeModel extends CategoryType {
  const CategoryTypeModel({
    required super.type,
    required super.duration,
  });

  // to db (sqlite)
  Map<String, dynamic> toDb() {
    return {
      'type': type,
      'duration': duration,
    };
  }

  // from localdb (sqlite)
  factory CategoryTypeModel.fromDb(Map<String, dynamic> map) {
    return CategoryTypeModel(
      type: map['type']?.toString() ?? '',
      duration: map['duration'] is int
          ? map['duration']
          : int.tryParse(map['duration']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'duration': duration,
    };
  }

  // From API (JSON format)
  factory CategoryTypeModel.fromMap(Map<String, dynamic> json) {
    return CategoryTypeModel(
      type: json['type']?.toString() ?? '',
      duration: json['duration'] is int
          ? json['duration']
          : int.tryParse(json['duration']?.toString() ?? '0') ?? 0,
    );
  }

  // Convert to entity
  CategoryType toEntity() {
    return CategoryType(
      type: type,
      duration: duration,
    );
  }

  // Create from entity
  factory CategoryTypeModel.fromEntity(CategoryType entity) {
    return CategoryTypeModel(
      type: entity.type,
      duration: entity.duration,
    );
  }
}
