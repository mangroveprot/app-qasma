import '../../domain/entites/category_type.dart';

class CategoryTypeModel extends CategoryType {
  const CategoryTypeModel({
    required super.type,
    required super.duration,
  });

  static String _getString(
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

    return '';
  }

  static int _getInt(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    final value1 = map[key1];
    if (value1 is int) return value1;
    if (value1 != null) {
      final parsed = int.tryParse(value1.toString());
      if (parsed != null) return parsed;
    }

    if (key2 != null) {
      final value2 = map[key2];
      if (value2 is int) return value2;
      if (value2 != null) {
        final parsed = int.tryParse(value2.toString());
        if (parsed != null) return parsed;
      }
    }

    return 0;
  }

  Map<String, dynamic> toDb() {
    return {
      'type': type,
      'duration': duration,
    };
  }

  factory CategoryTypeModel.fromDb(Map<String, dynamic> map) {
    return CategoryTypeModel(
      type: _getString(map, 'type'),
      duration: _getInt(map, 'duration'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'duration': duration,
    };
  }

  factory CategoryTypeModel.fromMap(Map<String, dynamic> json) {
    return CategoryTypeModel(
      type: _getString(json, 'type'),
      duration: _getInt(json, 'duration'),
    );
  }

  CategoryType toEntity() {
    return CategoryType(
      type: type,
      duration: duration,
    );
  }

  factory CategoryTypeModel.fromEntity(CategoryType entity) {
    return CategoryTypeModel(
      type: entity.type,
      duration: entity.duration,
    );
  }

  @override
  String toString() {
    return 'CategoryTypeModel(type: $type, duration: $duration)';
  }
}
