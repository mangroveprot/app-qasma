import '../../domain/entites/category.dart';
import 'category_type_model.dart';

class CategoryModel extends Category {
  const CategoryModel({
    super.description,
    required super.types,
  });

  static String? _getStringNullable(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    if (map.containsKey(key1)) {
      final value = map[key1];
      if (value != null) return value.toString();
    }

    if (key2 != null && map.containsKey(key2)) {
      final value = map[key2];
      if (value != null) return value.toString();
    }

    return null;
  }

  static List<CategoryTypeModel> _getTypesList(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    final value1 = map[key1];
    if (value1 is List) {
      return value1
          .map((e) =>
              e is Map<String, dynamic> ? CategoryTypeModel.fromMap(e) : null)
          .whereType<CategoryTypeModel>()
          .toList();
    }

    if (key2 != null) {
      final value2 = map[key2];
      if (value2 is List) {
        return value2
            .map((e) =>
                e is Map<String, dynamic> ? CategoryTypeModel.fromMap(e) : null)
            .whereType<CategoryTypeModel>()
            .toList();
      }
    }

    return [];
  }

  Map<String, dynamic> toDb() {
    return {
      'description': description ?? '',
      'types':
          types.map((t) => CategoryTypeModel.fromEntity(t).toDb()).toList(),
    };
  }

  factory CategoryModel.fromDb(Map<String, dynamic> map) {
    return CategoryModel(
      description: _getStringNullable(map, 'description'),
      types: _getTypesList(map, 'types'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description ?? '',
      'types':
          types.map((t) => CategoryTypeModel.fromEntity(t).toMap()).toList(),
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> json) {
    return CategoryModel(
      description: json['description'] as String?,
      types: _getTypesList(json, 'types'),
    );
  }

  Category toEntity() {
    return Category(
      description: description,
      types: types,
    );
  }

  factory CategoryModel.fromEntity(Category entity) {
    return CategoryModel(
      description: entity.description,
      types: entity.types,
    );
  }

  @override
  String toString() {
    return 'CategoryModel(description: $description, types: $types)';
  }
}
