import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../infrastructure/injection/service_locator.dart';

void GlobalErrorHandling() {
  final _logger = sl<Logger>();

  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.toString().contains('mouse_tracker.dart')) {
      return;
    }

    _logger.w(
      'Flutter framework error detected in ${FlutterError.onError.runtimeType}.\n'
      'Error: ${details.exceptionAsString()}\n'
      'StackTrace: ${details.stack ?? StackTrace.current}',
    );

    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }
  };

  runZonedGuarded(() {
    // runApp(MyApp()); should be called from main
  }, (error, stackTrace) {
    _logger.w(
      'Sync conflict detected in runZonedGuarded, attempting resolution.\n'
      'Error: $error\n'
      'StackTrace: $stackTrace',
    );
  });
}
