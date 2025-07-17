import 'app_config.dart';

class URLProviderConfig {
  // base
  String get baseURL => AppConfig.baseUrl;

  // path
  String get apiPath => '/api';

  // endpoints
  String get authEndPoint => '${apiPath}/auth';
  String get userEndPoint => '${apiPath}/user';

  // Auth URLS
  String get register => '${authEndPoint}/register';
  String get login => '${authEndPoint}/login';
  String get verify => '${authEndPoint}/verify';
  String get refreshTokenUrl => '${authEndPoint}/refresh';

  // User URLS
  String get getProfile => '${userEndPoint}/getProfile';

  String addPathSegments(String baseUrl, List<String> segments) {
    final String cleanedBase = baseUrl.replaceFirst(RegExp(r'/+$'), '');

    final List<String> cleanedSegments =
        segments
            .map((s) => s.trim().replaceAll(RegExp(r'^/+|/+$'), ''))
            .where((s) => s.isNotEmpty)
            .toList();
    return '$cleanedBase/${cleanedSegments.join('/')}';
  }
}
