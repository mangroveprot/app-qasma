import 'app_config.dart';

class URLProviderConfig {
  // base
  String get baseURL => AppConfig.baseUrl;

  // path
  String get apiPath => '/api';

  // endpoints
  String get authEndPoint => '${apiPath}/auth';
  String get userEndPoint => '${apiPath}/user';
  String get configEndPoint => '${apiPath}/config';
  String get appointmentEndPoint => '${apiPath}/appointment';

  // Auth URLS
  String get register => '${authEndPoint}/register';
  String get login => '${authEndPoint}/login';
  String get verify => '${authEndPoint}/verify';
  String get refreshTokenUrl => '${authEndPoint}/refresh';

  // User URLS
  String get getProfile => '${userEndPoint}/getProfile';
  String get isRegister => '${userEndPoint}/isRegister';

  // Config URLS
  String get getConfig => '${configEndPoint}/';

  // Appointment URLS
  String get getAllAppointmentByUser => '${appointmentEndPoint}/getAllByUser';
  String get getSlots => '${appointmentEndPoint}/slots';

  String addPathSegments(String baseUrl, List<String> segments) {
    final String cleanedBase = baseUrl.replaceFirst(RegExp(r'/+$'), '');

    final List<String> cleanedSegments = segments
        .map((s) => s.trim().replaceAll(RegExp(r'^/+|/+$'), ''))
        .where((s) => s.isNotEmpty)
        .toList();
    return '$cleanedBase/${cleanedSegments.join('/')}';
  }
}
