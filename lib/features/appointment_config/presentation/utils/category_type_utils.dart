// utils/category_type_utils.dart

import '../../data/models/category_type_model.dart';

class CategoryView {
  final String description;
  final List<CategoryTypeModel> types;

  const CategoryView({
    this.description = '',
    required this.types,
  });

  CategoryView copyWith({
    String? description,
    List<CategoryTypeModel>? types,
  }) {
    return CategoryView(
      description: description ?? this.description,
      types: types ?? this.types,
    );
  }
}

class CategoryTypeUtils {
  /// Deep copy a map of categories (with description and types)
  static Map<String, CategoryView> deepCopy(
      Map<String, CategoryView> original) {
    return original.map((category, view) => MapEntry(
          category,
          CategoryView(
            description: view.description,
            types: view.types
                .map((t) =>
                    CategoryTypeModel(type: t.type, duration: t.duration))
                .toList(),
          ),
        ));
  }

  /// Check if two category maps are equal (both description and types)
  static bool isEqual(
      Map<String, CategoryView> map1, Map<String, CategoryView> map2) {
    if (map1.length != map2.length) return false;

    for (final category in map1.keys) {
      if (!map2.containsKey(category)) return false;

      final a = map1[category]!;
      final b = map2[category]!;

      if ((a.description.trim()) != (b.description.trim())) return false;

      final list1 = a.types;
      final list2 = b.types;
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

  /// Process categories by:
  /// - trimming names/descriptions
  /// - filtering out empty types
  /// - keeping only categories that have at least one non-empty type
  static Map<String, CategoryView> processForSave(
      Map<String, CategoryView> categories) {
    final processed = <String, CategoryView>{};

    categories.forEach((category, view) {
      final filteredTypes =
          view.types.where((type) => type.type.trim().isNotEmpty).toList();
      if (filteredTypes.isNotEmpty) {
        processed[category.trim()] = view.copyWith(
            description: view.description.trim(), types: filteredTypes);
      }
    });

    return processed;
  }

  /// Convert categories to API format:
  /// {
  ///   "<categoryName>": {
  ///     "description": "<desc>",
  ///     "types": [ { "type": "...", "duration": 30 }, ... ]
  ///   },
  ///   ...
  /// }
  static Map<String, Map<String, dynamic>> toApiFormat(
      Map<String, CategoryView> categories) {
    return categories.map((category, view) => MapEntry(
          category,
          {
            'description': view.description.trim(),
            'types': view.types
                .map((t) => {'type': t.type.trim(), 'duration': t.duration})
                .toList(),
          },
        ));
  }

  /// Initialize categories from config data (backward compatible):
  /// Accepts either:
  /// - { "<name>": { "description": "...", "types": [ {type, duration}, ... ] } }
  /// - { "<name>": [ CategoryType or {type,duration}, ... ] }  // legacy
  /// - { "<name>": Category/CategoryModel }  // parsed entity
  static Map<String, CategoryView> fromConfigData(
      Map<String, dynamic>? categoryAndType) {
    if (categoryAndType == null) return {};

    final result = <String, CategoryView>{};

    categoryAndType.forEach((category, value) {
      String description = '';
      List<CategoryTypeModel> types = [];

      if (value is Map<String, dynamic>) {
        // New structure
        description = (value['description'] ?? '').toString();

        final dynamic list = value['types'];
        if (list is List) {
          types = list.map((e) {
            if (e is CategoryTypeModel) {
              return CategoryTypeModel(type: e.type, duration: e.duration);
            } else if (e is Map<String, dynamic>) {
              final t = e['type']?.toString() ?? '';
              final d = e['duration'];
              final duration =
                  d is int ? d : int.tryParse(d?.toString() ?? '') ?? 0;
              return CategoryTypeModel(type: t, duration: duration);
            } else {
              // Try dynamic access (legacy entity with fields)
              try {
                final t = (e as dynamic).type?.toString() ?? '';
                final d = (e as dynamic).duration;
                final duration =
                    d is int ? d : int.tryParse(d?.toString() ?? '') ?? 0;
                return CategoryTypeModel(type: t, duration: duration);
              } catch (_) {
                return const CategoryTypeModel(type: '', duration: 0);
              }
            }
          }).toList();
        }
      } else if (value is List) {
        // Legacy structure: only list of types
        types = value.map((e) {
          if (e is CategoryTypeModel) {
            return CategoryTypeModel(type: e.type, duration: e.duration);
          } else if (e is Map<String, dynamic>) {
            final t = e['type']?.toString() ?? '';
            final d = e['duration'];
            final duration =
                d is int ? d : int.tryParse(d?.toString() ?? '') ?? 0;
            return CategoryTypeModel(type: t, duration: duration);
          } else {
            try {
              final t = (e as dynamic).type?.toString() ?? '';
              final d = (e as dynamic).duration;
              final duration =
                  d is int ? d : int.tryParse(d?.toString() ?? '') ?? 0;
              return CategoryTypeModel(type: t, duration: duration);
            } catch (_) {
              return const CategoryTypeModel(type: '', duration: 0);
            }
          }
        }).toList();
      } else {
        // Parsed entity object (Category/CategoryModel)
        try {
          description = (value as dynamic).description?.toString() ?? '';
          final dynamic list = (value as dynamic).types;
          if (list is List) {
            types = list.map((e) {
              if (e is CategoryTypeModel) {
                return CategoryTypeModel(type: e.type, duration: e.duration);
              } else if (e is Map<String, dynamic>) {
                final t = e['type']?.toString() ?? '';
                final d = e['duration'];
                final duration =
                    d is int ? d : int.tryParse(d?.toString() ?? '') ?? 0;
                return CategoryTypeModel(type: t, duration: duration);
              } else {
                try {
                  final t = (e as dynamic).type?.toString() ?? '';
                  final d = (e as dynamic).duration;
                  final duration =
                      d is int ? d : int.tryParse(d?.toString() ?? '') ?? 0;
                  return CategoryTypeModel(type: t, duration: duration);
                } catch (_) {
                  return const CategoryTypeModel(type: '', duration: 0);
                }
              }
            }).toList();
          }
        } catch (_) {
          // leave defaults
        }
      }

      result[category] = CategoryView(
        description: description,
        types: types,
      );
    });

    return result;
  }
}
