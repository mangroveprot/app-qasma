import '../../common/utils/form_field_config.dart';

class AppRouteExtractor {
  static T? extractModel<T>(dynamic extra) {
    if (extra is T) return extra;

    if (extra is Map && extra.isNotEmpty) {
      final firstValue = extra.values.first;
      return firstValue is T ? firstValue : null;
    }

    return null;
  }

  static Map<String, String> extractFieldData(
    dynamic extra,
    List<FormFieldConfig> routeFields,
  ) {
    if (extra != null && extra is Map<String, dynamic>) {
      return {
        for (final field in routeFields)
          field.field_key: extra[field.field_key]?.toString() ?? '',
      };
    }

    return {for (final field in routeFields) field.field_key: ''};
  }

  static T? extractRaw<T>(dynamic extra) {
    return extra is T ? extra : null;
  }

  static bool hasExtraData(dynamic extra) {
    return extra != null;
  }

  static dynamic getRawExtra(dynamic extra) {
    return extra;
  }
}
