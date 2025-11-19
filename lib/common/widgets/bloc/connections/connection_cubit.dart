import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'connections_cubit_state.dart';

class ConnectionCubit extends Cubit<ConnectionCubitState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  Timer? _connectionCheckTimer;

  static const Duration _checkInterval = Duration(seconds: 15);
  static const Duration _fastTimeout = Duration(seconds: 5);
  static const Duration _slowTimeout = Duration(seconds: 20);
  static const int _maxRetries = 3;

  ConnectionCubit() : super(ConnectionChecking()) {
    _checkConnectionStatus();
    _startMonitoring();
  }

  void _startMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((_) {
      Timer(const Duration(milliseconds: 500), () {
        _checkConnectionStatus();
      });
    });

    _connectionCheckTimer =
        Timer.periodic(_checkInterval, (_) => _checkConnectionStatus());
  }

  Future<void> _checkConnectionStatus() async {
    // debug always connection as online
    if (kDebugMode) {
      _emitIfChanged(ConnectionOnline());
      return;
    }

    final result = await _connectivity.checkConnectivity();

    if (result == ConnectivityResult.none) {
      _emitIfChanged(ConnectionOffline());
      return;
    }

    final hasInternet = await _hasInternetAccessProgressive();

    if (hasInternet) {
      _emitIfChanged(ConnectionOnline());
    } else {
      _emitIfChanged(ConnectionOffline());
    }
  }

  Future<bool> _hasInternetAccessProgressive() async {
    if (await _hasInternetAccess(_fastTimeout)) {
      return true;
    }

    if (await _hasInternetAccess(_slowTimeout)) {
      return true;
    }

    return await _tryAlternativeEndpoints();
  }

  Future<bool> _hasInternetAccess(Duration timeout) async {
    try {
      final response = await http
          .get(Uri.parse('https://clients3.google.com/generate_204'))
          .timeout(timeout);
      return response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _tryAlternativeEndpoints() async {
    final endpoints = [
      'https://connectivitycheck.gstatic.com/generate_204',
      'https://www.google.com/favicon.ico',
      'https://httpbin.org/status/200',
    ];

    for (final endpoint in endpoints) {
      for (int retry = 0; retry < _maxRetries; retry++) {
        try {
          final response =
              await http.head(Uri.parse(endpoint)).timeout(_slowTimeout);

          if (response.statusCode >= 200 && response.statusCode < 300) {
            return true;
          }
        } catch (_) {
          if (retry < _maxRetries - 1) {
            await Future.delayed(Duration(milliseconds: 500 * (retry + 1)));
          }
        }
      }
    }

    return false;
  }

  void _emitIfChanged(ConnectionCubitState newState) {
    if (state.runtimeType != newState.runtimeType) {
      emit(newState);
    }
  }

  void retryConnectionCheck() {
    emit(ConnectionChecking());
    _checkConnectionStatus();
  }

  Future<void> forceConnectionCheck() async {
    emit(ConnectionChecking());

    await Future.delayed(const Duration(milliseconds: 300));

    await _checkConnectionStatus();
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _connectionCheckTimer?.cancel();
    return super.close();
  }
}
