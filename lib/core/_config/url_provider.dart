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
  String get otpEndPoint => '${apiPath}/otp';

  // Auth URLS
  String get login => '${authEndPoint}/login';
  String get verify => '${authEndPoint}/verify';
  String get refreshTokenUrl => '${authEndPoint}/refresh';
  String get verifyURL => '${authEndPoint}/verify';
  String get forgotPassword => '${authEndPoint}/forgot-password';
  String get resendOtpUrl => '${authEndPoint}/resendOTP';
  String get resetPasswordUrl => '${authEndPoint}/reset-password';
  String get changePasswordUrl => '${authEndPoint}/change-password';
  String get logoutUrl => '${authEndPoint}/logout';
  String get userUpdateUrl => '${authEndPoint}/update';

  // OTP URLS
  String get generateOtp => '${otpEndPoint}/generate';

  // User URLS
  String get getProfile => '${userEndPoint}/getProfile';
  String get isRegister => '${userEndPoint}/isRegister';
  String get register => '${userEndPoint}/';

  // Config URLS
  String get getConfig => '${configEndPoint}/';

  // Appointment URLS
  String get newAppointment => '${appointmentEndPoint}/';
  String get updateAppointment => '${appointmentEndPoint}/update';
  String get getAllAppointmentByUser => '${appointmentEndPoint}/getAllByUser';
  String get getSlots => '${appointmentEndPoint}/slots';
  String get counselorsAvailability =>
      '${appointmentEndPoint}/counselors/availability';
  String get cancelAppointment => '${appointmentEndPoint}/cancel';
  String get acceptAppointment => '${appointmentEndPoint}/accept';

  String addPathSegments(String baseUrl, List<String> segments) {
    final String cleanedBase = baseUrl.replaceFirst(RegExp(r'/+$'), '');

    final List<String> cleanedSegments = segments
        .map((s) => s.trim().replaceAll(RegExp(r'^/+|/+$'), ''))
        .where((s) => s.isNotEmpty)
        .toList();
    return '$cleanedBase/${cleanedSegments.join('/')}';
  }

  String getFullPath(String basePath, [List<String> segments = const []]) {
    final cleanedBase = basePath.replaceFirst(RegExp(r'/+$'), '');
    final cleanedSegments = segments
        .map((s) => s.trim().replaceAll(RegExp(r'^/+|/+$'), ''))
        .where((s) => s.isNotEmpty)
        .toList();

    return '$cleanedBase/${cleanedSegments.join('/')}';
  }
}
