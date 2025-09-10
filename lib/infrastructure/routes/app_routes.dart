class Routes {
  // paths
  static const String root = '/';
  static const String common = '/common';
  static const String aut_path = '/auth';
  static const String user_path = '/user';
  static const String home_path = '/home';
  static const String appointment = '/appointment';
  static const String appointment_config = '/appointment-config';
  static const String preference_path = '/preference';

  // auth route names
  static const String create_account = 'create-account';
  static const String get_started = 'get-started';
  static const String otp_verification = 'otp-verification';
  static const String login = 'login';
  static const String forgot_password = 'forgot-password';
  static const String reset_password = 'reset-password';
  static const String change_password = 'change-password';

  // user route names
  static const String user_profile = 'user-profile';
  static const String user_page = 'user-page';
  static const String schedule = 'schedule';

  // home route names

  // appointment routes names
  static const String appointment_history = 'appointment-history';
  static const String qr_scan = 'qr-scan';

  // appointment config routes names
  static const String basic_config = 'basic-config';
  static const String reminders_config = 'reminders-config';
  static const String categories_and_types = 'categories_and_types';

  // preference routes name
  static const String settings = 'settings';
  static const String privacy_policy = 'privacy-policy';
  static const String terms_conditons = 'terms-conditions';
  static const String about = 'about';

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
