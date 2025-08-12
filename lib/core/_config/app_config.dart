import 'package:logger/logger.dart';

import '../../common/error/app_error.dart';
import 'flavor_config.dart';

class AppConfig {
  final Logger _logger = Logger();

  // initialize
  Future<void> init() async {
    try {
      _logger.i(
        'AppConfig initialized with flavor: ${FlavorConfig.instance.flavor}',
      );
      _logger.i('Base URL: $baseUrl');
      _logger.i('Logging enabled: $shouldShowLogs');
      _logger.i('App Title: $appTitle');
    } catch (e, stackTrace) {
      _logger.e('Error initializing AppConfig: $e');
      AppError.create(
        message: 'Error initializing AppConfig',
        type: ErrorType.configuration,
        originalError: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // config getters
  static String get baseUrl => FlavorConfig.instance.values.baseUrl;
  static String get appTitle => FlavorConfig.instance.values.appTitle;
  static bool get shouldShowLogs => FlavorConfig.instance.values.enableLogging;

  // flavor type check
  static bool get isProduction => FlavorConfig.isProduction();
  static bool get isDevelopment => FlavorConfig.isDevelopment();

  static Map<String, dynamic> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'x-app-flavor': FlavorConfig.instance.flavor.toString().split('.').last,
      };

  // Timeouts (in milliseconds)
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // Retry Configuration
  static const int maxRetries = 3;
  static const int retryDelay = 1000; // milliseconds

  static String get databaseName => FlavorConfig.instance.values.databaseName;
  static int get dbVersion => 1;
}
