import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../infrastructure/injection/service_locator.dart';

void GlobalErrorHandling() {
  final logger = sl<Logger>();

  FlutterError.onError = (FlutterErrorDetails details) {
    logger.e(
      'Flutter Error ❌: ${details.exceptionAsString()}',
      error: details.exception,
      stackTrace: details.stack,
    );

    // if (kDebugMode) {
    //   FlutterError.presentError(details);
    // }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    logger.e('Dart Error ❌: $error', error: error, stackTrace: stack);
    return true;
  };
}
