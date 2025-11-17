import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../core/_base/_services/package_info/package_info_service.dart';
import '../../../../core/_base/_services/storage/shared_preference.dart';
import '../../../../features/update/data/models/release_info_model.dart';
import '../../../../features/update/domain/usecases/check_update_usecase.dart';
import '../../../../infrastructure/injection/service_locator.dart';

part 'update_cubit_state.dart';

class UpdateCubit extends Cubit<UpdateCubitState> with WidgetsBindingObserver {
  final CheckUpdateUsecase _checkUpdateUsecase = sl<CheckUpdateUsecase>();
  final _logger = Logger();

  static const String _lastCheckKey = 'last_update_check_time';
  static const Duration _minCheckInterval = Duration(hours: 6);

  String? _cachedCurrentVersion;
  String? _cachedCurrentBuild;

  UpdateCubit() : super(const UpdateInitial()) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initializeVersionInfo();
      _checkIfNeeded();
      WidgetsBinding.instance.addObserver(this);
    });
  }

  Future<void> _initializeVersionInfo() async {
    try {
      final packageInfo = sl<PackageInfoService>();
      _cachedCurrentVersion = packageInfo.version;
      _cachedCurrentBuild = packageInfo.buildNumber;
      _logger.d(
          'Cached version info: $_cachedCurrentVersion-$_cachedCurrentBuild');
    } catch (e) {
      _logger.e('Failed to get package info', e);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _logger.d('App resumed, checking if update check needed');
      _checkIfNeeded();
    }
  }

  Future<void> _checkIfNeeded() async {
    // if (kDebugMode) {
    //   _logger.d('Debug mode: Checking for updates immediately');
    //   await checkForUpdates();
    //   return;
    // }

    final now = DateTime.now();
    final lastCheckStr = SharedPrefs().getString(_lastCheckKey);

    DateTime? lastCheckTime;
    if (lastCheckStr != null) {
      lastCheckTime = DateTime.tryParse(lastCheckStr);
    }

    final shouldCheck = lastCheckTime == null ||
        now.difference(lastCheckTime) > _minCheckInterval;

    if (shouldCheck) {
      final timeSinceLast = lastCheckTime != null
          ? now.difference(lastCheckTime).inMinutes
          : null;
      _logger.i(
          'Performing update check (last check: ${timeSinceLast ?? "never"} minutes ago)');
      await checkForUpdates();
    } else {
      final minutesUntilNext =
          _minCheckInterval.inMinutes - now.difference(lastCheckTime).inMinutes;
      _logger
          .d('Skipping update check. Next check in $minutesUntilNext minutes');
    }
  }

  Future<void> checkForUpdates({bool force = false}) async {
    await SharedPrefs()
        .setString(_lastCheckKey, DateTime.now().toIso8601String());

    emit(UpdateChecking(
      currentVersion: _cachedCurrentVersion,
      currentBuild: _cachedCurrentBuild,
    ));

    try {
      final result = await _checkUpdateUsecase.call();

      result.fold(
        (error) {
          _logger.e('Update check failed: ${error.message}');
          emit(UpdateCheckFailed(
            error.message ?? 'Unknown error has occurred',
            currentVersion: _cachedCurrentVersion,
            currentBuild: _cachedCurrentBuild,
          ));
        },
        (updateInfo) async {
          final hasUpdate = updateInfo['hasUpdate'] as bool;
          final currentVersion = updateInfo['currentVersion'] as String?;
          final currentBuild = updateInfo['currentBuild'] as String?;

          _cachedCurrentVersion = currentVersion ?? _cachedCurrentVersion;
          _cachedCurrentBuild = currentBuild ?? _cachedCurrentBuild;

          _logger.d('UpdateInfo map: ${updateInfo.toString()}');

          if (hasUpdate) {
            final latestVersion = updateInfo['latestVersion'] as String;
            final latestBuild = updateInfo['latestBuild'] as String;

            _logger.i('Update available: $latestVersion (Build: $latestBuild)');
            emit(UpdateAvailable(
              currentVersion: currentVersion!,
              currentBuild: currentBuild!,
              latestRelease: updateInfo['releaseInfo'] as ReleaseInfoModel,
            ));
          } else {
            _logger.d('App is up to date');
            emit(UpdateNotAvailable(
              currentVersion: currentVersion!,
              currentBuild: currentBuild!,
            ));
          }
        },
      );
    } catch (e, stack) {
      _logger.e('Unexpected error during update check', e, stack);
      emit(UpdateCheckFailed(
        'Unexpected error: $e',
        currentVersion: _cachedCurrentVersion,
        currentBuild: _cachedCurrentBuild,
      ));
    }
  }

  void reset() {
    emit(UpdateInitial(
      currentVersion: _cachedCurrentVersion,
      currentBuild: _cachedCurrentBuild,
    ));
  }

  Future<void> forceCheck() async {
    _logger.i('Force checking for updates');
    await checkForUpdates(force: true);
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
