class Routes {
  // paths
  static const String root = '/';
  static const String aut_path = '/auth';

  // route names
  static const String create_account = 'create-account';
  static const String get_started = 'get-started';
  static const String otp_verification = 'otp-verification';
  static const String login = 'login';
  static const String forgot_password = 'forgot-password';

  static String buildPath(String basePath, String routeName) {
    if (basePath.isEmpty || routeName.isEmpty) {
      throw ArgumentError('Base path and route name cannot be empty');
    }

    // check basePath starts with '/' and doesn't end with '/'
    String normalizedBasePath =
        basePath.startsWith('/') ? basePath : '/$basePath';
    if (normalizedBasePath.endsWith('/') && normalizedBasePath.length > 1) {
      normalizedBasePath = normalizedBasePath.substring(
        0,
        normalizedBasePath.length - 1,
      );
    }

    // check if routeName doesn't start with '/'
    final String normalizedRouteName =
        routeName.startsWith('/') ? routeName.substring(1) : routeName;

    return '$normalizedBasePath/$normalizedRouteName';
  }

  static String composePath(String basePath, [List<String>? paths]) {
    final List<String> segments = [basePath];
    if (paths != null) {
      segments.addAll(paths);
    }
    return nested(segments);
  }

  /// Example:
  /// ```dart
  /// RouteHelper.nested(['auth', 'user', 'profile']); // Returns: '/auth/user/profile'
  /// ```
  static String nested(List<String> segments) {
    if (segments.isEmpty) {
      throw ArgumentError('Segments list cannot be empty');
    }

    return '/${segments.join('/')}';
  }
}
