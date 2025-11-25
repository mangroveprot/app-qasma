class Routes {
  // paths
  static const String root = '/';
  static const String aut_path = '/auth';
  static const String user_path = '/user';
  static const String home_path = '/home';
  static const String appointment = '/appointment';
  static const String preference_path = '/preference';
  static const String notifications = '/notifications';

  // auth route names
  static const String create_account = 'create-account';
  static const String get_started = 'get-started';
  static const String otp_verification = 'otp-verification';
  static const String login = 'login';
  static const String forgot_password = 'forgot-password';
  static const String reset_password = 'reset-password';
  static const String change_password = 'change-password';
  static const String user_profile = 'user-profile';

  // home route names

  // appointment routes names
  static const String appointment_history = 'appointment-history';

  // preference routes name
  static const String about = 'about';
  static const String helpAndSupport = 'help-and-support';

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
}
