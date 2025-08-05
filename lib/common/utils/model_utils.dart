class ModelUtils {
  static String getString(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    return map[key1]?.toString() ?? map[key2]?.toString() ?? '';
  }

  static String? getNullableString(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    final value = map[key1]?.toString() ?? map[key2]?.toString();
    return value?.isEmpty == true ? null : value;
  }

  static int getInt(Map<String, dynamic> map, String key1, [String? key2]) {
    final value = map[key1] ?? (key2 != null ? map[key2] : null);
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static int? getNullableInt(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    final value = map[key1] ?? (key2 != null ? map[key2] : null);
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double getDouble(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    final value = map[key1] ?? (key2 != null ? map[key2] : null);
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static double? getNullableDouble(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    final value = map[key1] ?? (key2 != null ? map[key2] : null);
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static DateTime getDateTime(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    final value = map[key1]?.toString() ?? map[key2]?.toString();
    if (value != null && value.isNotEmpty) {
      return DateTime.parse(value);
    }
    return DateTime.now();
  }

  static DateTime? getNullableDateTime(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    final raw = map.containsKey(key1)
        ? map[key1]
        : (key2 != null && map.containsKey(key2) ? map[key2] : null);
    final value = raw?.toString();
    if (value != null && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static bool getBool(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  static bool? getNullableBool(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    final value = map[key1] ?? (key2 != null ? map[key2] : null);
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true';
    return null;
  }

  static List<T>? getNullableList<T>(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    final value = map[key1] ?? (key2 != null ? map[key2] : null);
    if (value is List) {
      return value.cast<T>();
    }
    return null;
  }

  static Map<String, dynamic>? getNullableMap(
    Map<String, dynamic> map,
    String key1, [
    String? key2,
  ]) {
    final value = map[key1] ?? (key2 != null ? map[key2] : null);
    if (value is Map<String, dynamic>) {
      return value;
    }
    return null;
  }

  static String? getValue(Map<String, dynamic> map, String key) {
    final value = map[key];
    return value != null ? value.toString() : null;
  }

  static bool hasValue(Map<String, dynamic> map, String key) {
    return map.containsKey(key) && map[key] != null;
  }

  static bool hasAnyValue(Map<String, dynamic> map, List<String> keys) {
    return keys.any((key) => hasValue(map, key));
  }

  static T? getFirstNonNull<T>(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      if (hasValue(map, key)) {
        return map[key] as T?;
      }
    }
    return null;
  }
}
