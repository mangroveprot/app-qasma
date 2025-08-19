class OtherInfoRules {
  /// Allowed keys per role.
  static const Map<String, List<String>> allowedKeys = {
    'student': ['course', 'yearLevel', 'block'],
    'staff': [], // staff has no other_info
    'counselor': ['unavailableTimes'],
  };

  /// Sanitize incoming other_info according to the user's role.
  /// - student: keep {course, yearLevel, block}
  /// - staff: always {}
  /// - counselor: keep {unavailableTimes} and normalize its shape
  static Map<String, dynamic> sanitize(
      String role, Map<String, dynamic> input) {
    final normalizedRole = role.toLowerCase();
    if (normalizedRole == 'staff') return {}; // DB is NOT NULL, so we store {}

    final allowed = allowedKeys[normalizedRole]?.toSet() ?? const {};
    final filtered = <String, dynamic>{};

    for (final e in input.entries) {
      if (!allowed.contains(e.key)) continue;

      if (normalizedRole == 'counselor' && e.key == 'unavailableTimes') {
        filtered[e.key] = _sanitizeUnavailableTimes(e.value);
      } else {
        filtered[e.key] = e.value;
      }
    }
    return filtered;
  }

  /// Ensures the counselor shape is:
  /// Map<String, List<Map<String, String>>> {
  ///   "Monday": [{"start":"08:00","end":"09:00"}, ...],
  ///   ...
  /// }
  static Map<String, List<Map<String, String>>> _sanitizeUnavailableTimes(
      dynamic v) {
    if (v is! Map) return {};
    final out = <String, List<Map<String, String>>>{};

    v.forEach((day, slots) {
      if (slots is! List) return;
      final clean = <Map<String, String>>[];
      for (final s in slots) {
        if (s is Map && s['start'] != null && s['end'] != null) {
          final start = s['start'].toString();
          final end = s['end'].toString();
          if (_looksLikeTime(start) &&
              _looksLikeTime(end) &&
              start.compareTo(end) < 0) {
            clean.add({'start': start, 'end': end});
          }
        }
      }
      out[day.toString()] = clean;
    });

    return out;
  }

  /// Very light HH:mm check. Tighten if you need strict validation.
  static bool _looksLikeTime(String t) {
    final re = RegExp(r'^\d{2}:\d{2}$');
    return re.hasMatch(t);
  }
}
