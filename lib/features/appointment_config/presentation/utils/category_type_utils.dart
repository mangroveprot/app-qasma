// utils/category_type_utils.dart

import '../../data/models/category_type_model.dart';

class CategoryTypeUtils {
  /// Deep copy a map of category types
  static Map<String, List<CategoryTypeModel>> deepCopy(
      Map<String, List<CategoryTypeModel>> original) {
    return original.map((category, types) => MapEntry(
        category,
        types
            .map((type) =>
                CategoryTypeModel(type: type.type, duration: type.duration))
            .toList()));
  }

  /// Check if two category type maps are equal
  static bool isEqual(Map<String, List<CategoryTypeModel>> map1,
      Map<String, List<CategoryTypeModel>> map2) {
    if (map1.length != map2.length) return false;

    for (final category in map1.keys) {
      if (!map2.containsKey(category)) return false;
      final list1 = map1[category]!;
      final list2 = map2[category]!;

      if (list1.length != list2.length) return false;
      for (int i = 0; i < list1.length; i++) {
        if (list1[i].type.trim() != list2[i].type.trim() ||
            list1[i].duration != list2[i].duration) {
          return false;
        }
      }
    }
    return true;
  }

  /// Process category types by filtering out empty types
  static Map<String, List<CategoryTypeModel>> processForSave(
      Map<String, List<CategoryTypeModel>> categoryTypes) {
    final processed = <String, List<CategoryTypeModel>>{};

    categoryTypes.forEach((category, types) {
      final filteredTypes =
          types.where((type) => type.type.trim().isNotEmpty).toList();
      if (filteredTypes.isNotEmpty) {
        processed[category] = filteredTypes;
      }
    });

    return processed;
  }

  /// Convert category types to map format for API
  static Map<String, List<Map<String, dynamic>>> toApiFormat(
      Map<String, List<CategoryTypeModel>> categoryTypes) {
    return categoryTypes.map((category, types) => MapEntry(
        category,
        types
            .map(
                (type) => {'type': type.type.trim(), 'duration': type.duration})
            .toList()));
  }

  /// Initialize category types from config data
  static Map<String, List<CategoryTypeModel>> fromConfigData(
      Map<String, dynamic>? categoryAndType) {
    if (categoryAndType == null) return {};

    final newCategoryTypes = <String, List<CategoryTypeModel>>{};
    categoryAndType.forEach((category, types) {
      if (types is List) {
        newCategoryTypes[category] = types
            .map((type) => CategoryTypeModel(
                type: type.type.trim(), duration: type.duration))
            .toList();
      }
    });

    return newCategoryTypes;
  }
}
