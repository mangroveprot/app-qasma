import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Flavor { development, production }

class FlavorValues {
  final String baseUrl;
  final String appTitle;
  final bool enableLogging;
  final String databaseName;

  FlavorValues(Flavor flavor)
      : baseUrl =
            _getEnvVar('API_BASE_URL', flavor) ?? 'https://api.example.com',
        appTitle = _getEnvVar('APP_TITLE', flavor) ??
            (flavor == Flavor.production ? 'App' : 'App Dev'),
        enableLogging = flavor == Flavor.production
            ? (_getEnvVar('ENABLE_LOGGING', flavor)?.toLowerCase() == 'true')
            : true, // Always true for dev
        databaseName = _getEnvVar('DATABASE_NAME', flavor) ?? 'app_database';

  static String? _getEnvVar(String key, Flavor flavor) {
    try {
      final value = dotenv.env[key];
      if (value == null || value.isEmpty) {
        // Log that the environment variable is missing
        print(
            'WARNING: Environment variable $key is missing or empty for $flavor');
        return null;
      }
      return value;
    } catch (e) {
      // Log any errors when accessing environment variables
      print(
          'ERROR: Failed to access environment variable $key for $flavor: $e');
      return null;
    }
  }
}

class FlavorConfig {
  final Flavor flavor;
  final FlavorValues values;
  static FlavorConfig? _instance;

  factory FlavorConfig({required Flavor flavor}) {
    _instance ??= FlavorConfig._internal(flavor, FlavorValues(flavor));
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.values);

  static FlavorConfig get instance {
    assert(_instance != null, 'FlavorConfig must be initialized first');
    return _instance!;
  }

  static bool isProduction() => _instance?.flavor == Flavor.production;
  static bool isDevelopment() => _instance?.flavor == Flavor.development;
}
