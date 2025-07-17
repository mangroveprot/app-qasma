import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Flavor { development, production }

class FlavorValues {
  final String baseUrl;
  final String appTitle;
  final bool enableLogging;
  final String databaseName;

  FlavorValues(Flavor flavor)
    : baseUrl = dotenv.env['API_BASE_URL'] ?? 'https://api.example.com',
      appTitle =
          dotenv.env['APP_TITLE'] ??
          (flavor == Flavor.production ? 'App' : 'App Dev'),
      enableLogging =
          flavor == Flavor.production
              ? (dotenv.env['ENABLE_LOGGING']?.toLowerCase() == 'true')
              : true, // Always true for dev
      databaseName = dotenv.env['DATABASE_NAME'] ?? 'app_database';
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
