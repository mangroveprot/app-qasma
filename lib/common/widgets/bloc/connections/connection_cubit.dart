import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'connections_cubit_state.dart';

class ConnectionCubit extends Cubit<ConnectionCubitState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  Timer? _connectionCheckTimer;

  ConnectionCubit() : super(ConnectionChecking()) {
    _checkConnectionStatus();
    _startMonitoring();
  }

  void _startMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((_) {
      _checkConnectionStatus();
    });

    _connectionCheckTimer = Timer.periodic(
        const Duration(seconds: 10), (_) => _checkConnectionStatus());
  }

  Future<void> _checkConnectionStatus() async {
    final result = await _connectivity.checkConnectivity();

    if (result == ConnectivityResult.none) {
      _emitIfChanged(ConnectionOffline());
      return;
    }

    final hasInternet = await _hasInternetAccess();

    if (hasInternet) {
      _emitIfChanged(ConnectionOnline());
    } else {
      _emitIfChanged(ConnectionOffline());
    }
  }

  Future<bool> _hasInternetAccess() async {
    try {
      final response = await http
          .get(Uri.parse('https://clients3.google.com/generate_204'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }

  void _emitIfChanged(ConnectionCubitState newState) {
    if (state != newState) {
      emit(newState);
    }
  }

  void retryConnectionCheck() {
    emit(ConnectionChecking());
    _checkConnectionStatus();
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _connectionCheckTimer?.cancel();
    return super.close();
  }
}
